local addon, ns = ...

local hearth = { 166747, 208704, 188952, 190196, 172179, 166746, 162973, 
				 163045, 209035, 168907, 184353, 165669, 182773, 180290, 
				 165802, 200630, 165670, 212337, 193588 };

local eToys = { 18986, 30544, 48933, 87215, 112059, 172924 };				
local randHearth = {};
		
local function iniDB()
	--Initialize the database
	PortalWindowDB = PortalWindowDB or {};
	PortalWindowDB.Hearthstones = PortalWindowDB.Hearthstones or {};
	PortalWindowDB.eToy = PortalWindowDB.eToy or {};
	local hFlag = false;
	for k,v in pairs(hearth) do
		PortalWindowDB.Hearthstones[v] = PortalWindowDB.Hearthstones[v] or {};
		PortalWindowDB.Hearthstones[v].icon  = PortalWindowDB.Hearthstones[v].icon or 134400;
		if PortalWindowDB.Hearthstones[v].icon  == 134400 then hFlag = true; end;
		PortalWindowDB.Hearthstones[v].name  = PortalWindowDB.Hearthstones[v].name or "Hearthstone";
		if PortalWindowDB.Hearthstones[v].name  == "Hearthstone" then hFlag = true; end;
	end;	
	local eFlag = false;
	for k,v in pairs(eToys) do
		PortalWindowDB.eToy[v] = PortalWindowDB.eToy[v] or {};
		PortalWindowDB.eToy[v].icon  = PortalWindowDB.eToy[v].icon or 134400;
		if PortalWindowDB.eToy[v].icon  == 134400 then eFlag = true; end;
		PortalWindowDB.eToy[v].name  = PortalWindowDB.eToy[v].name or "Engineer Toy";
		if PortalWindowDB.eToy[v].name  == "Engineer Toy" then eFlag = true; end;
	end;		
	return hFlag, eFlag;
end;

local function getHearthstoneDetail()
	local flag = false;
	for k,v in pairs(PortalWindowDB.Hearthstones) do
		local id, name, icon, _ =  C_ToyBox.GetToyInfo(k);
		if v.name == "Hearthstone" and name then v.name = name; end;
		if v.name == "Hearthstone" then flag = true; end;
		if v.icon == 134400 and icon then v.icon = icon; end;
		if v.icon == 134400 then flag = true; end;	
	end;
	return flag;
end;

local function geteToyDetails()
	local flag = false;
	for k,v in pairs(PortalWindowDB.eToy) do
		local id, name, icon, _ =  C_ToyBox.GetToyInfo(k);
		if v.name == "Engineer Toy" and name then v.name = name; end;
		if v.name == "Engineer Toy" then flag = true; end;
		if v.icon == 134400 and icon then v.icon = icon; end;
		if v.icon == 134400 then flag = true; end;	
	end;
	return flag;
end;


local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

eventFrame:SetScript("OnEvent", function(self, event, arg1, arg2, ...) 
	if event == "ADDON_LOADED" then
		if arg1 == addon then
			ns:iniCompartmentFrame();
			local hFlag, eFlag = iniDB();
			
			if hFlag or eFlag then C_Timer.NewTicker(5, function (self) 
					if hFlag then hFlag = getHearthstoneDetail(); end;
					if eFlag then eFlag = geteToyDetails(); end;
				end, 10 ); 
			end;
			if WorldMapFrame then
				WorldMapFrame:HookScript("OnShow", function(self)				
					local btn = CreateFrame("Button",  nil, self, "GameMenuButtonTemplate");
					--position, size and add title to the frame
					btn:SetSize(70,  WorldMapFrame.SidePanelToggle:GetHeight());
					btn:SetText("Portals");
					btn:SetNormalFontObject("GameFontNormal");
					btn:SetHighlightFontObject("GameFontHighlight");
					btn:SetPoint("TOPRIGHT", WorldMapFrame.SidePanelToggle, "TOPLEFT");	
					btn:SetFrameStrata("HIGH");
					btn:SetScript("OnClick", function(self)
						WorldMapFrameCloseButton:Click();
						ns:loadPortalWindow();
					end)
				end)
			end;
		end;
	end;	
	if event == "PLAYER_ENTERING_WORLD" then
		ns:createQuickPickFrame (CharacterFrame);			
		eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	end;
end); 



