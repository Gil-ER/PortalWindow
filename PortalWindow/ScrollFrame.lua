local addon, ns = ...

local function addButton(f, id, detail, savedName)
	local b =  CreateFrame("BUTTON", nil, f, "SecureActionButtonTemplate");
	b:SetSize(48, 48);
	b:RegisterForClicks("LeftButtonUp", "LeftButtonDown", "RightButtonUp", "RightButtonDown");
	b:SetAttribute("type1","macro");
	local name, icon;
	if detail then name = detail.name; icon = detail.icon;
	else name, _, icon, _ =  GetSpellInfo(id); end;
	b.id = id;
	b.icon = icon;
	if savedName then b.name = savedName else b.name = name; end;
	b.command = name;
	b.parent = f;
	b.itemType = f.itemType;
	b:SetNormalTexture(icon);
	b:SetAttribute("macrotext1", "/use " .. b.command);
	b:SetPoint("TOPLEFT", f, "TOPLEFT", 10, 50);
	b.text = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
	b.text:SetPoint( "TOPLEFT", b, "CENTER", 35, 5 );
	b.text:SetText(b.name);	
	b:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, "ANCHOR_NONE");
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT");
		GameTooltip:ClearLines(); 
		if self.itemType == "toy" then GameTooltip:SetItemByID(self.id); 
		elseif self.itemType == "spell" then GameTooltip:SetSpellByID(self.id); end;
		GameTooltip:Show();
	end);		
	b:SetScript("OnLeave", function(self) GameTooltip:Hide(); end);	
	b.cdFrame = CreateFrame("Frame", nil, f);
	b.cdFrame:SetSize(b:GetSize());
	b.cdFrame:SetPoint(b:GetPoint());
	b.texture = b.cdFrame:CreateTexture();
	b.texture:SetAllPoints();
	b.texture:SetTexture(b.icon);
	b.cd = CreateFrame("Cooldown", nil, b.cdFrame, "CooldownFrameTemplate");
	b.cd:SetAllPoints();	
	function b.checkCD()	
		local desatFlag;
		if f.itemType == "spell" then desatFlag, _ = IsUsableSpell(b.command); end;
		if f.itemType == "toy" then desatFlag = PlayerHasToy(b.id); end;
		ns.setDesaturation(b.texture, desatFlag);
		local s, d;
		if f.itemType == "toy" then s, d, _ = GetItemCooldown(b.id); end;
		if f.itemType == "spell" then s, d, _ = GetSpellCooldown(b.id); end;	
		b.cd:SetCooldown(s, d);
	end;
	function b.isUsable() 
		local flag = true;
		if f.itemType == "spell" then flag = IsUsableSpell(b.command); end;
		if f.itemType == "toy" then flag = PlayerHasToy(b.id); end;	
		return flag;
	end;
	function b.position(y)
		b:SetPoint("TOPLEFT", b.parent, "TOPLEFT", 10, y);		
		b.cdFrame:SetPoint(b:GetPoint());
	end;
	return b;	
end;

local function setFrame(f)
	-- step through f.list adding buttons as needed	
	local buttons = f.buttons
	for k,v in ipairs(f.list) do
		local mat = false;
		for key,button in pairs(buttons) do
			if button.id == v then mat = true; end;		
		end;
		if mat == false then
			--add the button 
			tinsert(buttons, addButton(f, v));
		end;
	end;
	local currenty = 0
	for k,v in pairs(buttons) do
		if ( not ns.knownOnly ) or v.isUsable() then v.position(currenty); currenty = currenty - 65;
		else v.position(50); end;
	end;	
	return buttons;
end;

local function setToyFrame(f)
	-- step through f.list adding buttons as needed	
	local buttons = f.buttons
	for k,v in pairs(f.list) do
		local mat = false;
		for key,button in pairs(buttons) do
			if button.id == k then mat = true; end;		
		end;
		if mat == false then
			--add the button 
			tinsert(buttons, addButton(f, k, v));
		end;
	end;
	local currenty = 0
	for k,v in pairs(buttons) do
		if ( not ns.knownOnly ) or v.isUsable() then v.position(currenty); currenty = currenty - 65;
		else v.position(50); end;
	end;	
	return buttons;
end;

local function addLabel(currentY, f, t)
	if currentY < 0 then currentY = currentY - 20; end;
	local l =  ns.portalWindow.dung:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	l:SetFont("Fonts\\FRIZQT__.TTF", 18);
	l:SetPoint("TOPLEFT", f, "TOPLEFT", 0, currentY );
	l:SetText(t);
	return l;
end;

local function setHeaderFrame(f)
	for pacKey, pacName in ipairs(f.list[1]) do
		--add header label
		if not f.labels[pacKey] then tinsert(f.labels, addLabel(50, f, pacName)); end;
		f.buttons[pacKey] = f.buttons[pacKey] or {};
		for k,v in pairs(ns[ns.ports[2][pacKey] ]) do
			local mat = false;
			for a,b in pairs(f.buttons[pacKey]) do
				if b.id == v.id then mat = true; end;
			end;
			if not mat then tinsert(f.buttons[pacKey], addButton(f, v.id, nil, v.name)); end;
		end;
		local currenty = 0;
		for pac, tbl in ipairs(f.buttons) do
			f.labels[pac]:SetPoint("TOPLEFT", f, "TOPLEFT", 0, currenty);
			currenty = currenty - 20 
			for k,v in pairs(f.buttons[pac]) do
				if ( not ns.knownOnly ) or v.isUsable() then v.position(currenty); currenty = currenty - 65; 
				else v.position(50); end;			
			end;
		end;		
	end; 
end;

function ns:newScrollFrame(parent, list, itemType, hList)
	-- (parent, list, itemType, [hList])
	-- parent	- Parten Frame
	-- List	- table containing itemIDs or headers
	-- itemType	- Type of item (spell, toy)
	-- hList - True if header list
	local width, height = parent:GetSize();
	local f = CreateFrame("Frame");	
	f.buttons = {};
	f.labels = {};
	f.hList = hList;
	f.list = list;
	f.itemType = itemType;
	f.parent = parent;	
	f.sFrame = CreateFrame("ScrollFrame", nil, parent, "ScrollFrameTemplate");
	f.sFrame:SetSize(width - 42, height - 15)
	f.sFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, -14);
	--place a scrollchild in the scroll Frame	
	f:SetSize(width, height);
	f.sFrame:SetScrollChild(f);
	f:SetScript("OnHide", function (self) self.sFrame:Hide(); end);
	f:SetScript("OnShow", function (self)
		if self.hList == nil then  
			if self.itemType == "spell" then f.buttons = setFrame(self); end;
			if self.itemType == "toy" then f.buttons = setToyFrame(self); end;			
		else 
			 setHeaderFrame(self);
		end;
	end);	
	function f:checkCD()
		if (#f.buttons < 1) then return; end;
		if f.hList then
			for a,b in pairs(f.buttons) do
				if #b > 0 then 
					for k,v in pairs(b) do v.checkCD(); end; 
				end;
			end;
		else			
			for k,v in pairs(f.buttons) do v.checkCD(); end;
		end
	end;	
	return f;
end;




