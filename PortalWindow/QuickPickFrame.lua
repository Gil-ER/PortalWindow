local addon, ns = ...


local rhButton;

function ns:createQuickPickFrame(parent)
	local f = CreateFrame("Frame", nil, parent, "DefaultPanelTemplate"); 
	f:SetSize(65, parent:GetHeight());
	f:SetPoint("TOPLEFT", parent, "TOPRIGHT", -5, 0 );	
	f:SetScript("OnShow", function(self)
		ns.myTimer = C_Timer.NewTicker(1, function(self) ns:checkCDs(); end);
	end);
	f:SetScript("OnHide", function(self) ns.myTimer:Cancel(); end);	
	-- Garrison Hearth 
	local opts = ns.garHearth; opts.name = "";		-- sets icon, id, itemType, name & command
	opts.parent = f; opts.currentx = 9; opts.currenty = -30; opts.size = 48; opts.anchor = "TOPLEFT";
	ns:createButton(opts);	
	-- Dalaran Hearth
	opts = ns.dalHearth; opts.name = "";
	opts.parent = f; opts.currentx = 9; opts.currenty = -80; opts.size = 48; opts.anchor = "TOPLEFT";
	ns:createButton(opts);
	-- Random Hearth
	opts = ns.rndHearth; opts.name = "Random Hearth";
	opts.parent = f; opts.currentx = 10; opts.currenty = -130; opts.size = 48; opts.anchor = "TOPLEFT";
	rhButton = ns:createButton(opts);
	rhButton.randomize(rhButton);
	-- Hearthstone
	opts = ns.rndHearth; opts.itemType = "item"; opts.name = "Hearthstone";
	opts.parent = f; opts.currentx = 10; opts.currenty = -180; opts.size = 48; opts.anchor = "TOPLEFT";	--currenty - 50 each button
	ns:createButton(opts);	
	-- Portal Window Button
	local btn = CreateFrame("Button",  nil, f, "GameMenuButtonTemplate");
	--position, size and add title to the frame
	btn:SetSize(55,  45);
	btn:SetText("All\nPorts");
	btn:SetNormalFontObject("GameFontNormal");
	btn:SetHighlightFontObject("GameFontHighlight");
	btn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 7, 2);	
	btn:SetFrameStrata("HIGH");
	btn:SetScript("OnClick", function(self)
		ns:loadPortalWindow();
	end)	
	f:SetPoint("TOPLEFT", parent, "TOPRIGHT", -5, 0 );
end;
