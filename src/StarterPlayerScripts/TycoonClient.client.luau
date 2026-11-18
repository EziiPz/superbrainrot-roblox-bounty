-- TycoonClient: HUD untuk sistem gacha & ekonomi tycoon.
-- UI dibangun SEKALI; setiap Sync hanya memperbarui teks label yang di-cache.
local Players=game:GetService('Players')
local RS=game:GetService('ReplicatedStorage')
local TS=game:GetService('TweenService')
local Rem=RS:WaitForChild('TycoonRemote')
local lp=Players.LocalPlayer
local pg=lp:WaitForChild('PlayerGui')

local pack=workspace:FindFirstChild('Basic_UI_Pack')
local templates=pack and pack:FindFirstChild('Templates')
local iconSrcs=templates and templates:FindFirstChild('ImageLabels')
local btnSrcs=templates and templates:FindFirstChild('ImageButtons')

local THEME={
	bg=Color3.fromRGB(16,13,30),
	bg2=Color3.fromRGB(30,25,52),
	card=Color3.fromRGB(38,30,64),
	stroke=Color3.fromRGB(120,95,190),
	gold=Color3.fromRGB(255,225,120),
	green=Color3.fromRGB(140,255,170),
	white=Color3.fromRGB(245,245,255),
	blue=Color3.fromRGB(160,200,255),
	dim=Color3.fromRGB(125,130,155),
}

local sg=Instance.new('ScreenGui')
sg.Name='TycoonHUD'; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=false; sg.Parent=pg
local uiRoot=Instance.new('Frame')
uiRoot.Name='UIRoot'; uiRoot.AnchorPoint=Vector2.new(0.5,0.5); uiRoot.Position=UDim2.new(0.5,0,0.5,0)
uiRoot.Size=UDim2.new(1,0,1,0); uiRoot.BackgroundTransparency=1; uiRoot.ClipsDescendants=false; uiRoot.Parent=sg
local uiScale=Instance.new('UIScale'); uiScale.Parent=uiRoot
local cam=workspace.CurrentCamera
local function fitUI()
	local vp=cam and cam.ViewportSize or Vector2.new(1280,720)
	local factor=math.clamp(math.min(vp.X/1280,vp.Y/720),0.65,1.2)
	uiScale.Scale=factor
	uiRoot.Size=UDim2.new(1/factor,0,1/factor,0)
end
if cam then cam:GetPropertyChangedSignal('ViewportSize'):Connect(fitUI) end
fitUI()

local function corner(o,px)
	local c=Instance.new('UICorner'); c.CornerRadius=UDim.new(0,px or 10); c.Parent=o; return c
end
local function stroke(o)
	local s=Instance.new('UIStroke'); s.Color=THEME.stroke; s.Thickness=1.5; s.Transparency=0.5; s.Parent=o; return s
end
local function panel(parent,pos,size,anchor)
	local f=Instance.new('Frame')
	f.Position=pos; f.Size=size; f.BackgroundColor3=THEME.bg; f.BackgroundTransparency=0.1; f.BorderSizePixel=0
	if anchor then f.AnchorPoint=anchor end
	corner(f,14); stroke(f); f.Parent=parent
	return f
end
local function txt(parent,value,pos,size,color,font,px,align)
	local t=Instance.new('TextLabel')
	t.Text=value; t.Position=pos; t.Size=size; t.BackgroundTransparency=1
	t.TextColor3=color or THEME.white; t.Font=font or Enum.Font.GothamBold; t.TextSize=px or 15
	t.TextXAlignment=align or Enum.TextXAlignment.Left; t.TextTruncate=Enum.TextTruncate.AtEnd
	t.Parent=parent
	return t
end
local function icon(name,parent,pos,size)
	local src=iconSrcs and iconSrcs:FindFirstChild(name)
	local i=src and src:Clone() or Instance.new('ImageLabel')
	i.Position=pos; i.Size=size; i.BackgroundTransparency=1; i.Parent=parent
	return i
end
local function comma(n)
	local s=tostring(math.floor(tonumber(n) or 0))
	local r=s:reverse()
	local withComma=r:gsub('(%d%d%d)','%1,')
	return (withComma:reverse():gsub('^,',''))
end

-- ================= TOP BAR (statistik) =================
local top=panel(uiRoot,UDim2.new(0.5,0,0,16),UDim2.new(0,720,0,58),Vector2.new(0.5,0))
local statsRow=Instance.new('Frame')
statsRow.Size=UDim2.new(1,-190,1,0); statsRow.BackgroundTransparency=1; statsRow.Parent=top
local statsLayout=Instance.new('UIListLayout')
statsLayout.FillDirection=Enum.FillDirection.Horizontal
statsLayout.VerticalAlignment=Enum.VerticalAlignment.Center
statsLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
statsLayout.Padding=UDim.new(0,44); statsLayout.Parent=statsRow
local function statGroup(iconName,color,px)
	local g=Instance.new('Frame')
	g.Size=UDim2.new(0,140,0,38); g.BackgroundTransparency=1; g.Parent=statsRow
	local ic=icon(iconName,g,UDim2.new(0,0,0.5,0),UDim2.new(0,32,0,32))
	ic.AnchorPoint=Vector2.new(0,0.5)
	local l=txt(g,'',UDim2.new(0,42,0,0),UDim2.new(1,-42,1,0),color,Enum.Font.GothamBlack,px)
	l.TextYAlignment=Enum.TextYAlignment.Center
	return l
end
local cashLabel=statGroup('Coins',THEME.gold,21)
local incomeLabel=statGroup('Gift',THEME.green,17)
local invLabel=statGroup('Inventory',Color3.fromRGB(200,210,255),15)

-- ================= PANEL KIRI: GACHA & UPGRADES =================
local left=panel(uiRoot,UDim2.new(0.012,0,0.16,0),UDim2.new(0,330,0,478)); left.Visible=false
local function tabBtn(label,pos)
	local b=Instance.new('TextButton')
	b.Position=pos; b.Size=UDim2.new(0.44,0,0,34)
	b.BackgroundColor3=THEME.card; b.BorderSizePixel=0
	b.Text=label; b.TextColor3=THEME.white; b.Font=Enum.Font.GothamBold; b.TextSize=14
	corner(b,8); stroke(b); b.Parent=left
	return b
end
local tabGacha=tabBtn('GACHA',UDim2.new(0.05,0,0.028,0))
local tabUpg=tabBtn('UPGRADES',UDim2.new(0.51,0,0.028,0))

-- --- konten tab GACHA ---
local gachaC=Instance.new('Frame')
gachaC.Position=UDim2.new(0.05,0,0,62); gachaC.Size=UDim2.new(0.9,0,0,400)
gachaC.BackgroundTransparency=1; gachaC.Parent=left
local eggHead=Instance.new('Frame')
eggHead.Size=UDim2.new(1,0,0,58)
eggHead.BackgroundColor3=THEME.bg2; eggHead.BackgroundTransparency=0.25; eggHead.BorderSizePixel=0
corner(eggHead,10); eggHead.Parent=gachaC
icon('Gift',eggHead,UDim2.new(0,10,0.5,0),UDim2.new(0,44,0,44)).AnchorPoint=Vector2.new(0,0.5)
local eggName=txt(eggHead,'',UDim2.new(0,64,0,6),UDim2.new(1,-74,0,24),THEME.gold,Enum.Font.GothamBlack,19)
local cdLabel=txt(eggHead,'',UDim2.new(0,64,0,31),UDim2.new(1,-74,0,20),THEME.blue,Enum.Font.Gotham,13)
txt(gachaC,'DROP RATES',UDim2.new(0,2,0,70),UDim2.new(1,0,0,22),THEME.gold,Enum.Font.GothamBlack,15)
local ratesHolder=Instance.new('Frame')
ratesHolder.Position=UDim2.new(0,0,0,98); ratesHolder.Size=UDim2.new(1,0,0,203)
ratesHolder.BackgroundTransparency=1; ratesHolder.Parent=gachaC
local ratesLayout=Instance.new('UIListLayout')
ratesLayout.Padding=UDim.new(0,3); ratesLayout.SortOrder=Enum.SortOrder.LayoutOrder; ratesLayout.Parent=ratesHolder
local rateRows={}
for i=1,7 do
	local row=Instance.new('Frame')
	row.Size=UDim2.new(1,0,0,26); row.BackgroundColor3=THEME.bg2; row.BackgroundTransparency=0.3; row.BorderSizePixel=0
	corner(row,6); row.Parent=ratesHolder
	local dot=Instance.new('Frame')
	dot.Position=UDim2.new(0,8,0.5,0); dot.AnchorPoint=Vector2.new(0,0.5); dot.Size=UDim2.new(0,10,0,10); dot.BorderSizePixel=0
	corner(dot,5); dot.Parent=row
	local name=txt(row,'',UDim2.new(0,26,0,0),UDim2.new(0.4,0,1,0),THEME.white,Enum.Font.GothamBold,13)
	local inc=txt(row,'',UDim2.new(0.42,0,0,0),UDim2.new(0.32,0,1,0),THEME.green,Enum.Font.Gotham,12)
	local pct=txt(row,'',UDim2.new(1,-58,0,0),UDim2.new(0,54,1,0),THEME.white,Enum.Font.GothamBlack,13,Enum.TextXAlignment.Right)
	rateRows[i]={row=row,dot=dot,name=name,inc=inc,pct=pct}
end
local hint=txt(gachaC,'Roll: dekat ROLL STICK  |  Hatch: dekat EGG PLACE',UDim2.new(0,2,0,318),UDim2.new(1,0,0,56),THEME.dim,Enum.Font.Gotham,12)
hint.TextWrapped=true

-- --- konten tab UPGRADES ---
local upgC=Instance.new('Frame')
upgC.Position=UDim2.new(0.05,0,0,62); upgC.Size=UDim2.new(0.9,0,0,400)
upgC.BackgroundTransparency=1; upgC.Visible=false; upgC.Parent=left
local function upgradeCard(pos,iconName,title)
	local card=Instance.new('Frame')
	card.Position=pos; card.Size=UDim2.new(1,0,0,150)
	card.BackgroundColor3=THEME.bg2; card.BackgroundTransparency=0.25; card.BorderSizePixel=0
	corner(card,10); card.Parent=upgC
	icon(iconName,card,UDim2.new(0,12,0,12),UDim2.new(0,38,0,38))
	txt(card,title,UDim2.new(0,60,0,10),UDim2.new(0.55,0,0,22),THEME.white,Enum.Font.GothamBlack,16)
	local lvl=txt(card,'Lv 1',UDim2.new(1,-70,0,10),UDim2.new(0,60,0,22),THEME.gold,Enum.Font.GothamBlack,16,Enum.TextXAlignment.Right)
	local eff=txt(card,'',UDim2.new(0,60,0,38),UDim2.new(1,-72,0,32),THEME.dim,Enum.Font.Gotham,12)
	eff.TextWrapped=true
	local cost=txt(card,'',UDim2.new(0,60,0,74),UDim2.new(1,-72,0,20),THEME.gold,Enum.Font.GothamBold,14)
	local buy=Instance.new('TextButton')
	buy.Position=UDim2.new(0.5,0,0,106); buy.Size=UDim2.new(0.5,0,0,32)
	buy.BackgroundColor3=THEME.card; buy.BorderSizePixel=0
	buy.Text='UPGRADE'; buy.TextColor3=THEME.white; buy.Font=Enum.Font.GothamBold; buy.TextSize=14
	corner(buy,8); stroke(buy); buy.Parent=card
	return {lvl=lvl,eff=eff,cost=cost,buy=buy}
end
local luckCard=upgradeCard(UDim2.new(0,0,0,0),'Upgrade','EGG LUCK')
local speedCard=upgradeCard(UDim2.new(0,0,0,166),'Rebirth','ROLL SPEED')
luckCard.buy.MouseButton1Click:Connect(function() Rem:FireServer('UpgradeLuck') end)
speedCard.buy.MouseButton1Click:Connect(function() Rem:FireServer('UpgradeSpeed') end)
local upgHint=txt(upgC,'Upgrade luck menaikkan peluang egg langka; upgrade speed mempercepat cooldown roll.',UDim2.new(0,2,0,336),UDim2.new(1,0,0,50),THEME.dim,Enum.Font.Gotham,12)
upgHint.TextWrapped=true

local function selectTab(isGacha)
	tabGacha.BackgroundColor3=isGacha and THEME.stroke or THEME.card
	tabUpg.BackgroundColor3=isGacha and THEME.card or THEME.stroke
	gachaC.Visible=isGacha; upgC.Visible=not isGacha
end
tabGacha.MouseButton1Click:Connect(function() selectTab(true) end)
tabUpg.MouseButton1Click:Connect(function() selectTab(false) end)
selectTab(true)

-- ================= PANEL KANAN: INVENTORI & PLATFORM =================
local right=panel(uiRoot,UDim2.new(0.988,0,0.16,0),UDim2.new(0,310,0,478),Vector2.new(1,0)); right.Visible=false
icon('Inventory',right,UDim2.new(0,14,0.035,0),UDim2.new(0,26,0,26))
local invHeader=txt(right,'BRAINROTS (0)',UDim2.new(0,50,0.045,0),UDim2.new(0.7,0,0,24),THEME.gold,Enum.Font.GothamBlack,17)
local scroll=Instance.new('ScrollingFrame')
scroll.Position=UDim2.new(0.05,0,0,54); scroll.Size=UDim2.new(0.9,0,0,180)
scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=4
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.Parent=right
local scrollLayout=Instance.new('UIListLayout')
scrollLayout.Padding=UDim.new(0,4); scrollLayout.Parent=scroll
local invRows={}
local function makeInvRow()
	local row=Instance.new('Frame')
	row.Size=UDim2.new(1,0,0,40); row.BackgroundColor3=THEME.bg2; row.BackgroundTransparency=0.25; row.BorderSizePixel=0
	corner(row,8); row.Parent=scroll
	local bar=Instance.new('Frame')
	bar.Size=UDim2.new(0,5,1,0); bar.BorderSizePixel=0; bar.Parent=row
	corner(bar,3)
	local name=txt(row,'',UDim2.new(0,14,0,3),UDim2.new(1,-16,0,20),Color3.fromRGB(240,245,255),Enum.Font.GothamBold,13)
	local inc=txt(row,'',UDim2.new(0,14,0,22),UDim2.new(1,-16,0,16),THEME.green,Enum.Font.Gotham,12)
	return {row=row,bar=bar,name=name,inc=inc}
end
txt(right,'PLATFORMS',UDim2.new(0.05,0,0,246),UDim2.new(0.9,0,0,22),THEME.gold,Enum.Font.GothamBlack,15)
local slotsGrid=Instance.new('Frame')
slotsGrid.Position=UDim2.new(0.05,0,0,272); slotsGrid.Size=UDim2.new(0.9,0,0,110)
slotsGrid.BackgroundTransparency=1; slotsGrid.Parent=right
local slotLabels={}
for i=1,10 do
	local col=(i-1)%2; local rw=math.floor((i-1)/2)
	slotLabels[i]=txt(slotsGrid,'P'..i..' Empty',UDim2.new(col*0.5,2,rw*0.2,0),UDim2.new(0.5,-4,0.18,0),THEME.dim,Enum.Font.GothamBold,11)
end
local placeBtn=Instance.new('TextButton')
placeBtn.Position=UDim2.new(0.05,0,1,-46); placeBtn.Size=UDim2.new(0.9,0,0,38)
placeBtn.BackgroundColor3=THEME.card; placeBtn.BorderSizePixel=0
placeBtn.Text='SIMPAN KE BASE'; placeBtn.TextColor3=THEME.white; placeBtn.Font=Enum.Font.GothamBold; placeBtn.TextSize=14
corner(placeBtn,8); stroke(placeBtn); placeBtn.Parent=right
placeBtn.MouseButton1Click:Connect(function() Rem:FireServer('Place',0) end)

-- tombol toggle di top bar (kanan)
local function chip(label,offsetX,cb)
	local b=Instance.new('TextButton')
	b.Position=UDim2.new(1,offsetX,0.5,0); b.AnchorPoint=Vector2.new(1,0.5)
	b.Size=UDim2.new(0,84,0,34); b.BackgroundColor3=THEME.card; b.BorderSizePixel=0
	b.Text=label; b.TextColor3=THEME.white; b.Font=Enum.Font.GothamBold; b.TextSize=13
	corner(b,8); stroke(b); b.Parent=top
	b.MouseButton1Click:Connect(cb)
	return b
end
chip('GACHA',-92,function() left.Visible=not left.Visible end)
chip('BRAINROTS',-8,function() right.Visible=not right.Visible end)

-- ================= TOAST =================
local toast=panel(uiRoot,UDim2.new(0.5,0,0,86),UDim2.new(0,420,0,40),Vector2.new(0.5,0))
toast.Visible=false
local toastText=txt(toast,'',UDim2.new(0.02,0,0.08,0),UDim2.new(0.96,0,0.84,0),THEME.white,Enum.Font.GothamBold,15,Enum.TextXAlignment.Center)

-- ================= POPUP HASIL HATCH =================
local result=panel(uiRoot,UDim2.new(0.5,0,0.5,0),UDim2.new(0,400,0,220),Vector2.new(0.5,0.5)); result.Visible=false
icon('Gift',result,UDim2.new(0,20,0.5,0),UDim2.new(0,72,0,72)).AnchorPoint=Vector2.new(0,0.5)
local resultName=txt(result,'',UDim2.new(0,110,0,52),UDim2.new(1,-130,0,34),THEME.white,Enum.Font.GothamBlack,22)
local resultInfo=txt(result,'',UDim2.new(0,110,0,92),UDim2.new(1,-130,0,26),THEME.gold,Enum.Font.Gotham,15)
local closeBtn=Instance.new('TextButton')
closeBtn.Position=UDim2.new(0.5,0,1,-52); closeBtn.AnchorPoint=Vector2.new(0.5,0)
closeBtn.Size=UDim2.new(0,120,0,36); closeBtn.BackgroundColor3=THEME.card; closeBtn.BorderSizePixel=0
closeBtn.Text='CLOSE'; closeBtn.TextColor3=THEME.white; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=14
corner(closeBtn,8); stroke(closeBtn); closeBtn.Parent=result
closeBtn.MouseButton1Click:Connect(function() result.Visible=false end)

-- ================= UPDATE DATA =================
local tierColors={}
local lastEggIndex=-1
local lastNotify=0
local revealStamp=0

local function setRates(rates)
	for i=1,7 do
		local rate=rates[i]
		local r=rateRows[i]
		if rate then
			tierColors[i]=rate.Color
			r.dot.BackgroundColor3=rate.Color
			r.name.Text=rate.Name
			r.inc.Text='+$'..rate.Income..'/s'
			if rate.Rate>0 then
				r.pct.Text=string.format('%.1f%%',rate.Rate)
				r.pct.TextColor3=rate.Color
				r.name.TextColor3=THEME.white
				r.inc.TextColor3=THEME.green
			else
				r.pct.Text='-'
				r.pct.TextColor3=THEME.dim
				r.name.TextColor3=THEME.dim
				r.inc.TextColor3=THEME.dim
			end
		end
	end
end

local function setInventory(list)
	for i,item in ipairs(list) do
		local r=invRows[i]
		if not r then r=makeInvRow(); invRows[i]=r end
		r.row.Visible=true
		r.name.Text=item.Name
		r.inc.Text='+$'..item.Income..'/s'
		r.bar.BackgroundColor3=tierColors[item.Tier] or THEME.stroke
	end
	for i=#list+1,#invRows do invRows[i].row.Visible=false end
	invHeader.Text='BRAINROTS ('..#list..')'
end

Rem.OnClientEvent:Connect(function(action,data)
	if action=='Sync' then
		cashLabel.Text='$'..comma(data.cash)
		incomeLabel.Text='$'..comma(data.income)..'/s'
		invLabel.Text=#data.inventory..' items'
		eggName.Text=string.upper(data.egg)
		cdLabel.Text='Cooldown roll: '..string.format('%.1f',data.cooldown)..'s'
		luckCard.lvl.Text='Lv '..data.luck
		luckCard.cost.Text='Harga: $'..comma(data.luckCost)
		luckCard.eff.Text='+28% bobot egg langka per level'
		speedCard.lvl.Text='Lv '..data.speed
		speedCard.cost.Text='Harga: $'..comma(data.speedCost)
		speedCard.eff.Text='Cooldown roll jadi '..string.format('%.1f',data.cooldown)..'s'
		if data.eggIndex~=lastEggIndex then
			lastEggIndex=data.eggIndex
			setRates(data.rates)
		end
		setInventory(data.inventory)
		local occupied={}
		for _,slot in ipairs(data.slots) do occupied[slot.Index]=slot end
		for i=1,10 do
			local s=occupied[i]
			if s then
				slotLabels[i].Text='P'..i..'  '..s.Name
				slotLabels[i].TextColor3=THEME.gold
			else
				slotLabels[i].Text='P'..i..'  Empty'
				slotLabels[i].TextColor3=THEME.dim
			end
		end
	elseif action=='HatchStart' then
		revealStamp=revealStamp+1
		local stamp=revealStamp
		result.Visible=true
		resultName.Text='???'
		resultName.TextColor3=THEME.white
		resultInfo.Text='Randomizing...'
		local cands=data.Candidates or {}
		local dur=data.Duration or 2
		local t0=os.clock()
		if #cands>0 then
			task.spawn(function()
				local i=1
				while os.clock()-t0<dur and stamp==revealStamp do
					local c=cands[((i-1)%#cands)+1]
					resultName.Text=c.Name
					resultName.TextColor3=c.Color
					resultInfo.Text=c.Rarity
					i+=1
					task.wait(0.08)
				end
			end)
		end
	elseif action=='Result' then
		revealStamp=revealStamp+1
		result.Visible=true
		resultName.Text=data.Name
		resultName.TextColor3=data.Color
		resultInfo.Text=data.Rarity..'  |  +$'..data.Income..'/s'
		local stamp=revealStamp
		task.delay(4,function() if stamp==revealStamp then result.Visible=false end end)
		result.Size=UDim2.new(0,340,0,190)
		TS:Create(result,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,400,0,220)}):Play()
	elseif action=='Notify' then
		toastText.Text=tostring(data)
		toast.Visible=true
		toast.BackgroundTransparency=1
		TS:Create(toast,TweenInfo.new(0.25),{BackgroundTransparency=0.1}):Play()
		lastNotify=os.clock()
		local stamp=lastNotify
		task.delay(2.5,function()
			if stamp==lastNotify then
				local t=TS:Create(toast,TweenInfo.new(0.4),{BackgroundTransparency=1})
				t:Play()
				t.Completed:Connect(function() if stamp==lastNotify then toast.Visible=false end end)
			end
		end)
	end
end)
