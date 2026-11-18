local C={}
local ui=workspace:FindFirstChild('Basic_UI_Pack')
local ai=ui and ui:FindFirstChild('AssetIds')
C.Icons={}
if ai then for _,v in ipairs(ai:GetChildren()) do if v:IsA('StringValue') then C.Icons[v.Name]=v.Value end end end
C.Tiers={
  {Name='NORMAL',Folder='Normal',Income=2,Color=Color3.fromRGB(180,190,205)},
  {Name='ORO',Folder='Oro',Income=6,Color=Color3.fromRGB(255,215,90)},
  {Name='DIAMANTE',Folder='Diamante',Income=15,Color=Color3.fromRGB(110,220,255)},
  {Name='LAVA',Folder='Lava',Income=35,Color=Color3.fromRGB(255,120,70)},
  {Name='GALAXIA',Folder='Galaxia',Income=80,Color=Color3.fromRGB(190,120,255)},
  {Name='ARCOIRIS',Folder='Arcoiris',Income=180,Color=Color3.fromRGB(120,255,180)},
  {Name='HACKER',Folder='Hacker',Income=500,Color=Color3.fromRGB(100,255,120)},
}
C.Eggs={
  {Name='Starter Egg',Model='Starter Egg',MaxTier=1,Rates={100,0,0,0,0,0,0}},
  {Name='Common Egg',Model='Common Egg',MaxTier=2,Rates={70,30,0,0,0,0,0}},
  {Name='Uncommon Egg',Model='Uncommon Egg',MaxTier=3,Rates={35,40,25,0,0,0,0}},
  {Name='Rare Egg',Model='Rare Egg',MaxTier=4,Rates={10,30,35,25,0,0,0}},
  {Name='Epic Egg',Model='Epic Egg',MaxTier=5,Rates={0,15,30,30,25,0,0}},
  {Name='Legendary Egg',Model='Legendary Egg',MaxTier=6,Rates={0,0,20,30,30,20,0}},
  {Name='Mythic Egg',Model='Mythic Egg',MaxTier=7,Rates={0,0,0,20,35,30,15}},
  {Name='Angel Egg',Model='Angel Egg',MaxTier=7,Rates={0,0,0,0,20,50,30}},
}
C.RollWeights={40,25,15,10,6,3,1,0}
C.BaseRollCooldown=6
C.BaseLuckCost=300
C.BaseSpeedCost=400
local store=game:GetService('ServerStorage')
local modelRoot=store:FindFirstChild('brainrot model')
function C.FindAsset(name)
  if modelRoot then local found=modelRoot:FindFirstChild(name); if found then return found end end
  return store:FindFirstChild(name) or workspace:FindFirstChild(name)
end
function C.RollEggIndex(luck)
  local w={}
  for i,v in ipairs(C.RollWeights) do
    local mult=1
    if i>=4 then mult=mult*(1+0.28*(luck-1)) elseif i<=2 then mult=mult*(1-0.1*(luck-1)) end
    w[i]=math.max(0,v*mult)
  end
  local total=0; for _,v in ipairs(w) do total=total+v end
  local pick=math.random()*total; local acc=0
  for i,v in ipairs(w) do acc=acc+v; if pick<acc then return i end end
  return 1
end
function C.RollTier(eggIndex)
  local egg=C.Eggs[eggIndex]; local rates=egg.Rates
  local pick=math.random()*100; local acc=0
  for i=1,egg.MaxTier do acc=acc+rates[i]; if pick<acc then return i end end
  return 1
end
function C.PickName(tier)
  local folder=C.FindAsset(C.Tiers[tier].Folder)
  if not folder then return 'Brainrot' end
  local kids=folder:GetChildren()
  if #kids==0 then return 'Brainrot' end
  return kids[math.random(1,#kids)].Name
end
function C.RateTable(eggIndex)
  local egg=C.Eggs[eggIndex]; local out={}
  for i=1,#C.Tiers do table.insert(out,{Name=C.Tiers[i].Name,Rate=egg and egg.Rates[i] or 0,Color=C.Tiers[i].Color,Income=C.Tiers[i].Income}) end
  return out
end
return C
