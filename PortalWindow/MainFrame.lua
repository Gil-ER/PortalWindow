local addon, ns = ...

ns.knownOnly = false;

local buttons = {};
local views = {};
local rhButton;

ns.myTimer = nil;
				
local portals = { 10059, 11417, 11416, 11418, 11419, 11420, 32266, 32267, 49360, 49361, 33691, 
				  53142, 88345, 120146, 132620, 176244, 176246, 224871, 281400, 281402, 
				  344597, 395289};

local teleports = { 3561, 3567, 3562, 3563, 3565, 3566, 32271, 32272, 49359, 49358, 33690,  
					53140, 88342, 120145, 132621, 176248, 176242, 193759, 224869, 281403, 
					281404, 344587, 395277 };
						
						
function ns:checkCDs()
	for k,v in pairs (buttons) do v.checkCD(); end;
	for k,v in pairs(views) do if v.checkCD then v.checkCD(); end; end;
end;

function ns:createButton(opts)
	-- opts:	parent		Frame	-parent Frame
	--			icon		number	-icon id
	--			currentx	number	-right of new button
	--			currenty	number	-top of new button
	--			size		number	-size of square button
	--			anchor 		string	-"TOPRIGHT" or "TOPLEFT"
	--			id			string	-spellid
	--			itemType	string	-spell/toy 		
	--			name		string	-text to appear beside the button
	--			command		string	-name od spell/toy (for macro)
	local b =  CreateFrame("BUTTON", nil, opts.parent, "SecureActionButtonTemplate");
	b.id = opts.id
	b.command = opts.command;
	b.name = opts.name;
	b.itemType = opts.itemType;
	b:SetNormalTexture(opts.icon);
	b:SetSize(opts.size, opts.size);
	b:SetPoint(opts.anchor, opts.parent, opts.anchor, opts.currentx, opts.currenty);
	b:RegisterForClicks("LeftButtonUp", "LeftButtonDown", "RightButtonUp", "RightButtonDown");
	b:SetAttribute("type1","macro")
	b:SetAttribute("macrotext1", "/use " .. opts.command);
	b:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, "ANCHOR_NONE");
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT");
		GameTooltip:ClearLines(); 
		if b.itemType == "toy" then GameTooltip:SetItemByID(b.id); 
		elseif b.itemType == "item" then GameTooltip:SetItemByID(b.id);
		elseif b.itemType == "spell" then GameTooltip:SetSpellByID(b.id); end;
		GameTooltip:Show();
	end);
	b:SetScript("OnLeave", function(self) GameTooltip:Hide(); end);
	b.cdFrame = CreateFrame("Frame", nil, opts.parent);
	b.cdFrame:SetSize(b:GetSize());
	b.cdFrame:SetPoint(b:GetPoint());
	b.texture = b.cdFrame:CreateTexture();
	b.texture:SetAllPoints();
	b.texture:SetTexture(b.icon);	
	b.cd = CreateFrame("Cooldown", nil, b.cdFrame, "CooldownFrameTemplate");
	b.cd:SetAllPoints();	
	function b.checkCD()
		local desatFlag;
		if b.itemType == "spell" then desatFlag, _ = IsUsableSpell(b.command); end;
		if b.itemType == "item" then desatFlag = (GetItemCount(b.id) > 0); end;	
		if b.itemType == "toy" then desatFlag = PlayerHasToy(b.id); end;	
		ns.setDesaturation(b.texture, desatFlag);
		local s, d;
		if b.itemType == "toy" then s, d, _ = GetItemCooldown(b.id); end;
		if b.itemType == "item" then s, d, _ = GetItemCooldown(b.id); end;
		if b.itemType == "spell" then s, d, _ = GetSpellCooldown(b.id); end;	
		b.cd:SetCooldown(s, d);
	end;
	function b.randomize(b)
		local flag = false;
		local randHearth = {};
		for k,v in pairs(PortalWindowDB.Hearthstones) do
			if PlayerHasToy(k) then
				local t = {["id"] = k, ["icon"] = v.icon, ["name"] = v.name };
				tinsert(randHearth, t);
			end;
		end;
		local r = randHearth[random(#randHearth)];
		b.id = r.id;
		b.name = "Random Hearth"
		b.command = r.name;
		b.icon = r.icon;
		b.ItemType = "toy";
		
		b:SetAttribute("macrotext1", "/use " .. b.command);		
		b:SetNormalTexture(r.icon);
		b.texture:SetTexture(r.icon);		
	end;
	b:SetScript("PostClick", function(self)	
		if self.name == "Random Hearth" then self.randomize(self); end;
	end)
	tinsert(buttons, b)
	return b;
end;

local function showPorts(selection)
 		--Hide all scroll frames
		for _,v in pairs(views) do
			v:Hide();
		end;
		if selection == "" then
			ns.portalWindow.titleFrame:Show();
		elseif selection == "Hearthstones" then
			ns.portalWindow.hearths:Show(); ns.portalWindow.hearths.sFrame:Show();
		elseif selection == "Dungeon Portals" then 
			ns.portalWindow.dung:Show(); ns.portalWindow.dung.sFrame:Show();
		elseif selection == "Mage Portals" then
			ns.portalWindow.portals:Show(); ns.portalWindow.portals.sFrame:Show();
		elseif selection == "Mage Teleports" then
			ns.portalWindow.teleports:Show(); ns.portalWindow.teleports.sFrame:Show();
		elseif selection == "Engineer Portals" then
			ns.portalWindow.engineer:Show(); ns.portalWindow.engineer.sFrame:Show();
		end;
end;

function ns:setRandomHearth()
	if #list < 1 then return; end;
	local n = random(#list)
	local opts = {};
	opts.icon = list[n].icon; opts.id = list[n].id; opts.name = list[n].name; opts.command = list[n].name;
	opts.itemType = "toy"; opts.parent = ns.portalWindow; opts.currentx = -84; opts.currenty = -27; 
	opts.size = 32;opts.anchor = "TOPRIGHT"
	ns:createButton(opts);
end;

function ns:loadPortalWindow()	
	if ns.portalWindow then 
		ns.myTimer = C_Timer.NewTicker(1, function(self) ns:checkCDs(); end);
		ns.portalWindow:Show(); 
		showPorts("");
		return; 
	end;
	-- Filter
	local dlGroups = {"Dungeon Portals", "Hearthstones"}
	local _,_, classIndex = UnitClass("player");
	if classIndex == 8 then tinsert(dlGroups, "Mage Portals"); tinsert(dlGroups, "Mage Teleports"); end;
	local p1, p2, _ = GetProfessions();
	if p1 == 8 or p2 == 8 then tinsert(dlGroups, "Engineer Portals"); end;
	
	
	-- Create and define the frame
	local f = CreateFrame("Frame", "PortalWindowMainFrame", UIParent, "ButtonFrameTemplate"); 
	f:SetSize(460, 400);	f:SetPoint("CENTER", UIParent, "CENTER");
	_G[f:GetName() .. "TitleText"]:SetText("Portal Window");	
	_G[f:GetName() .. "Portrait"]:SetTexture("Interface\\Icons\\Inv_misc_rune_01");
	f:EnableMouse(true);
	f:SetMovable(true);
	f:SetUserPlaced(true); 
	f:RegisterForDrag("LeftButton");
	--Create a frame that will contain the scroll frames
	local sParent = CreateFrame("Frame", nil, f, "InsetFrameTemplate");
	local w = f:GetWidth() - 16;
	local h = f:GetHeight() - 95;
	
	sParent:SetSize(w, h );
	sParent:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -65);
	f.titleFrame = CreateFrame("Frame", nil, sParent, "InsetFrameTemplate");
	tinsert(views, f.titleFrame);
	f.titleFrame:SetSize(sParent:GetSize());
	f.titleFrame:SetPoint(sParent:GetPoint());	
	f.titleFrame.texture = f.titleFrame:CreateTexture();
	f.titleFrame.texture:SetAllPoints();
	f.titleFrame.texture:SetTexture("Interface\\AddOns\\PortalWindow\\PortalWindow_256.blp");
	
	--place a scroll frames 
	f.portals = ns:newScrollFrame(sParent, portals, "spell");					--Mage Portals  Frame
	tinsert(views, f.portals);
	f.teleports = ns:newScrollFrame(sParent, teleports, "spell");				--Mage Teleports  Frame
	tinsert(views, f.teleports);
	f.dung = ns:newScrollFrame(sParent, ns.ports, "spell", true);				--Dungeon Frame	
	tinsert(views, f.dung);
	f.hearths = ns:newScrollFrame(sParent, PortalWindowDB.Hearthstones, "toy");	--Hearthstone Frame
	tinsert(views, f.hearths);
	f.engineer = ns:newScrollFrame(sParent, PortalWindowDB.eToy, "toy");		--Hearthstone Frame
	tinsert(views, f.engineer);
	
	f:SetScript("OnDragStart", function(self) self:StartMoving() end);
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);		
	-- Add a dropList
	local selectedGroup, groupsList = ns:newDropList(f, 70, -30);
	groupsList:SetList(dlGroups);
	selectedGroup:SetScript("OnTextChanged", function(self)	showPorts(self:GetText()); end);
	-- Buttons for the top bar
	-- Garrison Hearth 
	local opts = ns.garHearth;		-- sets icon, id, itemType, name & command
	opts.parent = f; opts.currentx = -10; opts.currenty = -27; opts.size = 32; opts.anchor = "TOPRIGHT";
	ns:createButton(opts);
	-- Dalaran Hearth
	opts = ns.dalHearth;
	opts.parent = f; opts.currentx = -45; opts.currenty = -27; opts.size = 32; opts.anchor = "TOPRIGHT";
	ns:createButton(opts);
	-- Random Hearth
	opts = ns.rndHearth; opts.name = "Random Hearth";
	opts.parent = f; opts.currentx = -80; opts.currenty = -27; opts.size = 32; opts.anchor = "TOPRIGHT";
	rhButton = ns:createButton(opts);
	rhButton.randomize(rhButton);
	-- Hearthstone
	opts = ns.rndHearth; opts.itemType = "item"; opts.name = "Hearthstone";
	opts.parent = f; opts.currentx = -115; opts.currenty = -27; opts.size = 32; opts.anchor = "TOPRIGHT";
	ns:createButton(opts);	
	--Checkbox
	myCheckButton = CreateFrame("CheckButton", "PortalWindow_CheckButton", f, "ChatConfigCheckButtonTemplate");
	myCheckButton:SetPoint("BOTTOMLEFT", 15, 1);
	getglobal(myCheckButton:GetName() .. 'Text'):SetText("Show only if known.");
	myCheckButton:SetChecked(true);
	ns.knownOnly = true;
	myCheckButton:SetScript("OnClick", function(f)
		ns.knownOnly = myCheckButton:GetChecked();
		showPorts(selectedGroup:GetText())
	end);	
	--CD timer
	f:SetScript("OnHide", function(self) ns.myTimer:Cancel(); end);		
	ns.myTimer = C_Timer.NewTicker(1, function(self) ns:checkCDs(); end);
	ns.portalWindow = f;
	showPorts("");
end;

