local Players=game:GetService('Players')
local RS=game:GetService('ReplicatedStorage')
local Config=require(RS:WaitForChild('TycoonConfig'))
local Rem=RS:WaitForChild('TycoonRemote')
local ws=workspace
local eggPlace=ws:FindFirstChild('egg place')
local rollPart=ws:FindFirstChild('roll')
local base=ws:FindFirstChild('BASE')
local state={}
local placed={}
local lastRoll={}
local lastHatch={}
local currentEgg=1
local function notify(p,msg) Rem:FireClient(p,'Notify',msg) end
local function luckCost(level) return math.floor(Config.BaseLuckCost*(1.8^(level-1))) end
local function speedCost(level) return math.floor(Config.BaseSpeedCost*(1.8^(level-1))) end
local function rollCooldown(level) return math.max(1.2,Config.BaseRollCooldown/level) end
local function sync(p)
  local s=state[p]
  if not s then return end
  local slots={}
  for i,item in pairs(placed) do table.insert(slots,{Index=i,Name=item.Name,Tier=item.Tier,Income=item.Income,Owner=item.Owner}) end
  table.sort(slots,function(a,b) return a.Index<b.Index end)
  local inv={}
  for _,it in ipairs(s.inventory) do table.insert(inv,{Name=it.Name,Tier=it.Tier,Income=it.Income}) end
  Rem:FireClient(p,'Sync',{cash=math.floor(s.cash),income=s.income,inventory=inv,slots=slots,egg=Config.Eggs[currentEgg].Name,eggIndex=currentEgg,rates=Config.RateTable(currentEgg),luck=s.luck,speed=s.speed,luckCost=luckCost(s.luck),speedCost=speedCost(s.speed),cooldown=rollCooldown(s.speed),icons=Config.Icons,eggs=Config.Eggs})
end
local function recalc(p)
  local s=state[p]
  local total=0
  for _,item in pairs(placed) do if item.Owner==p.Name then total=total+item.Income end end
  s.income=total
end
local function setEgg(index)
  currentEgg=index
  local container=eggPlace and eggPlace:FindFirstChild('EGG')
  if not container and eggPlace then
    container=Instance.new('Model'); container.Name='EGG'; container.Parent=eggPlace
    container:MoveTo(Vector3.new(8.65,10.6,73.61))
  end
  if container then for _,child in ipairs(container:GetChildren()) do child:Destroy() end end
  local src=Config.FindAsset(Config.Eggs[index].Model)
  if src and eggPlace then
    local ok,c=pcall(function()
      local c=src:Clone(); c.Name='EGG'
      local target=container and container:GetPivot().Position or Vector3.new(8.65,10.6,73.61)
      c:MoveTo(target)
      c:ScaleTo(0.6)
      c.Parent=container
      return c
    end)
    if not ok then warn('egg clone failed',tostring(c)) end
  end
end
local function doRoll(p)
  local s=state[p]
  if not s then return end
  local cd=rollCooldown(s.speed)
  local now=os.clock()
  if lastRoll[p] and now-lastRoll[p]<cd then notify(p,'Stick recharging: '..math.ceil(cd-(now-lastRoll[p]))..'s'); return end
  lastRoll[p]=now
  local index=Config.RollEggIndex(s.luck)
  setEgg(index)
  notify(p,'Egg rerolled: '..Config.Eggs[index].Name)
  for _,pl in ipairs(Players:GetPlayers()) do sync(pl) end
end
local function shakeEgg()
  -- animasi egg bergetar sebelum hatch
  local container=eggPlace and eggPlace:FindFirstChild('EGG')
  local egg=container and container:FindFirstChild('EGG')
  if not egg then return end
  local baseCF=egg:GetPivot()
  task.spawn(function()
    for i=1,12 do
      if not egg.Parent then break end
      egg:PivotTo(baseCF*CFrame.new(math.random(-25,25)/100,math.random(-10,10)/100,0)*CFrame.Angles(0,0,math.rad(math.random(-8,8))))
      task.wait(0.045)
    end
    if egg.Parent then egg:PivotTo(baseCF) end
  end)
end
local function doHatch(p)
  local s=state[p]
  if not s then return end
  local hn=os.clock()
  if lastHatch[p] and hn-lastHatch[p]<1.5 then return end
  lastHatch[p]=hn
  local tier=Config.RollTier(currentEgg)
  local name=Config.PickName(tier)
  local t=Config.Tiers[tier]
  -- kirim kandidat acak ke client untuk animasi randomisasi
  local candidates={}
  for i=1,12 do
    local rt=Config.RollTier(currentEgg)
    local rn=Config.PickName(rt)
    local rtt=Config.Tiers[rt]
    table.insert(candidates,{Name=rn,Color=rtt.Color,Rarity=rtt.Name})
  end
  table.insert(candidates,{Name=name,Color=t.Color,Rarity=t.Name})
  Rem:FireClient(p,'HatchStart',{Duration=2.4,Candidates=candidates})
  shakeEgg()
  -- Brainrot -> Tool: model di-weld ke Handle supaya tidak jatuh/terlepas saat dipegang
  local tool=Instance.new('Tool')
  tool.Name=name
  tool.ToolTip=t.Name..'  |  +$'..t.Income..'/s'
  tool.CanBeDropped=false
  tool:SetAttribute('IconId',Config.Icons.Inventory or Config.Icons.Gift)
  tool:SetAttribute('Tier',t.Name)
  tool:SetAttribute('Income',t.Income)
  local handle=Instance.new('Part')
  handle.Name='Handle'; handle.Size=Vector3.new(1,1,1)
  handle.Transparency=1; handle.CanCollide=false; handle.CanQuery=false; handle.CanTouch=false
  handle.Massless=true; handle.Parent=tool
  local folder=Config.FindAsset(t.Folder)
  local src=folder and folder:FindFirstChild(name)
  if src then
    local ok,c=pcall(function()
      local c=src:Clone(); c.Name='Brainrot'
      -- ukuran & orientasi persis seperti di ServerStorage (tanpa scaling)
      local pivot=c:GetPivot()
      c:PivotTo(handle.CFrame*pivot.Rotation)
      c.Parent=handle
      for _,d in ipairs(c:GetDescendants()) do
        if d:IsA('BasePart') then
          d.CanCollide=false; d.CanQuery=false; d.Massless=true; d.Anchored=false
          local w=Instance.new('WeldConstraint'); w.Part0=handle; w.Part1=d; w.Parent=d
        end
      end
      return c
    end)
    if not ok then warn('brainrot tool build failed',tostring(c)) end
  end
  tool.GripPos=Vector3.new(0,-0.4,0)
  tool.Parent=p:FindFirstChild('Backpack') or p.Backpack
  local item={Name=name,Tier=tier,Income=t.Income,Tool=tool}
  table.insert(s.inventory,item)
  -- tunda hasil sampai animasi randomisasi di client selesai
  task.delay(2.4,function()
    if state[p] then
      notify(p,'Hatched '..name..' ('..t.Name..') - tool added to inventory')
      Rem:FireClient(p,'Result',{Name=name,Tier=tier,Rarity=t.Name,Color=t.Color,Income=t.Income})
      sync(p)
    end
  end)
end
local function doPlace(p,index)
  local s=state[p]
  if not s then return end
  if placed[index] then notify(p,'Platform '..index..' is occupied.'); return end
  -- Tool -> Model: pakai tool yang sedang dipegang pemain; fallback ke item pertama inventori
  local item
  local char=p.Character
  local held=char and char:FindFirstChildOfClass('Tool')
  if held then
    for i,it in ipairs(s.inventory) do
      if it.Tool==held then item=table.remove(s.inventory,i) break end
    end
  end
  if not item and #s.inventory>0 then item=table.remove(s.inventory,1) end
  if not item then notify(p,'Inventory empty. Hatch an egg first.'); return end
  if item.Tool and item.Tool.Parent then item.Tool:Destroy() end
  local backpack=p:FindFirstChild('Backpack')
  if backpack then for _,c in ipairs(backpack:GetChildren()) do if c:IsA('Tool') and c.Name==item.Name then c:Destroy() end end end
  if held and held.Parent then held:Destroy() end
  local platform=base and base:FindFirstChild('Platform'..index)
  local collector=platform and platform:FindFirstChild('Collector')
  if not collector then notify(p,'Platform '..index..' has no Collector.'); return end
  local folder=Config.FindAsset(Config.Tiers[item.Tier].Folder)
  local src=folder and folder:FindFirstChild(item.Name)
  if not src and folder then src=folder:GetChildren()[1] end
  local model=nil
  if src then
    local ok,c=pcall(function()
      local c=src:Clone(); c.Name='Display_'..item.Name
      -- ukuran & orientasi PERSIS seperti di ServerStorage (tanpa scaling)
      local pivot=c:GetPivot()
      local _,bbSize=c:GetBoundingBox()
      -- letakkan berdiri di atas part 'put brainrot here' milik platform
      local holder=platform:FindFirstChild('put brainrot here')
      local standPos=holder and (holder.Position+Vector3.new(0,holder.Size.Y/2,0))
        or (collector.Position+Vector3.new(0,collector.Size.Y/2,0))
      local maxAllowed=math.min(holder and holder.Size.X or 6,holder and holder.Size.Z or 6)*1.05
      local longest=math.max(bbSize.X,bbSize.Z)
      if longest>maxAllowed then
        c:ScaleTo(c:GetScale()*(maxAllowed/longest))
        local _,bb2=c:GetBoundingBox(); bbSize=bb2
      end
      c:PivotTo(CFrame.new(standPos+Vector3.new(0,bbSize.Y/2,0))*pivot.Rotation)
      local bbCF,bbS=c:GetBoundingBox()
      local delta=Vector3.new(standPos.X-bbCF.Position.X,standPos.Y-(bbCF.Position.Y-bbS.Y/2),standPos.Z-bbCF.Position.Z)
      c:PivotTo(c:GetPivot()+delta)
      c.Parent=workspace
      for _,d in ipairs(c:GetDescendants()) do
        if d:IsA('BasePart') then d.Anchored=true; d.CanCollide=false; d.CanQuery=false; d.CanTouch=false end
      end
      return c
    end)
    if ok then model=c end
  end
  placed[index]={Name=item.Name,Tier=item.Tier,Income=item.Income,Owner=p.Name,Model=model}
  recalc(p)
  notify(p,item.Name..' placed on Platform '..index..' (+$'..item.Income..'/s)')
  sync(p)
end
local function upgradeLuck(p)
  local s=state[p]; if not s then return end
  local cost=luckCost(s.luck)
  if s.cash<cost then notify(p,'Need $'..cost..' for luck upgrade.'); return end
  s.cash=s.cash-cost; s.luck=s.luck+1
  notify(p,'Egg luck upgraded to Lv'..s.luck..'! Better eggs are more likely.')
  sync(p)
end
local function upgradeSpeed(p)
  local s=state[p]; if not s then return end
  local cost=speedCost(s.speed)
  if s.cash<cost then notify(p,'Need $'..cost..' for speed upgrade.'); return end
  s.cash=s.cash-cost; s.speed=s.speed+1
  notify(p,'Roll speed upgraded to Lv'..s.speed..'! Cooldown '..rollCooldown(s.speed)..'s')
  sync(p)
end
Rem.OnServerEvent:Connect(function(p,action,arg)
  if action=='Roll' then doRoll(p)
  elseif action=='Hatch' then doHatch(p)
  elseif action=='Place' then
    local idx=tonumber(arg) or 0
    if idx<1 then
      idx=1
      while idx<=10 and placed[idx] do idx=idx+1 end
      if idx>10 then idx=0 end
    end
    if idx>0 then doPlace(p,idx) else notify(p,'All 10 platforms are full.') end
  elseif action=='UpgradeLuck' then upgradeLuck(p)
  elseif action=='UpgradeSpeed' then upgradeSpeed(p)
  end
end)
local function addPrompt(part,text,obj,callback)
  if not part then return end
  local pp=part:FindFirstChildOfClass('ProximityPrompt') or Instance.new('ProximityPrompt')
  pp.ActionText=text; pp.ObjectText=obj; pp.KeyboardKeyCode=Enum.KeyCode.E; pp.HoldDuration=0.15; pp.MaxActivationDistance=14; pp.Parent=part
  pp.Triggered:Connect(callback)
end
if rollPart then
  local stick=rollPart:FindFirstChild('roll stick') or rollPart
  addPrompt(stick,'Roll egg rarity','ROLL STICK',function(p) doRoll(p) end)
end
if eggPlace then addPrompt(eggPlace,'Hatch egg','EGG PLACE',function(p) doHatch(p) end) end
if base then
  for i=1,10 do
    local platform=base:FindFirstChild('Platform'..i)
    local collector=platform and platform:FindFirstChild('Collector')
    addPrompt(collector,'Place brainrot','PLATFORM '..i,function(p) doPlace(p,i) end)
  end
end
setEgg(1)
Players.PlayerAdded:Connect(function(p)
  state[p]={cash=500,income=0,inventory={},luck=1,speed=1}
  sync(p)
end)
Players.PlayerRemoving:Connect(function(p)
  for i,item in pairs(placed) do
    if item.Owner==p.Name then
      if item.Model and item.Model.Parent then item.Model:Destroy() end
      placed[i]=nil
    end
  end
  state[p]=nil; lastRoll[p]=nil; lastHatch[p]=nil
end)
while true do
  task.wait(1)
  for p,s in pairs(state) do s.cash=s.cash+s.income; sync(p) end
end
