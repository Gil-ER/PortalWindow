
local _, ns = ...
--Edit these to change paramaters
--EditBox:
local editBoxWidth = 210;
local editBoxHeight = 30;
local editBoxDefaultText = "";
--Button:
local buttonWidth = 25;
--dropFrame:
local dropFrameHeight = 300;
local dropFrameWidth = editBoxWidth --+ buttonWidth
--list:
local maxEntries = 20;
local lists = {};

function ns:newDropList(parent, xOff, yOff)
	--parent: 	Parent frame
	--xOff:		EditBox x position reletive to TOPRIGHT of parent
	--yOff:		EditBox y position reletive to TOPRIGHT of parent
	
	local list = {};
	--Add a EditBox
	local f = CreateFrame("EditBox", nil, parent, "InputBoxTemplate");
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff);
	f:SetWidth(editBoxWidth);
	f:SetHeight(30);
	f:SetEnabled(false);
	f:SetText(editBoxDefaultText)
	f:SetScript("OnShow", function(self) self.ebButton:Show(); end);
	f:SetScript("OnHide", function(self) self.ebButton:Hide(); end);
	function f:SetDefault()
		f:SetText(editBoxDefaultText);
	end;
	--Add a button to the right of the textbox
	f.ebButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate");
	f.ebButton:SetPoint("TOPLEFT", f, "TOPRIGHT", 0 , -2);
	f.ebButton:SetSize(buttonWidth, buttonWidth);	
	local fo = f.ebButton:CreateFontString("GameFontNormal");
	fo:SetFont("Fonts\\FRIZQT__.TTF", 11);
	fo:SetPoint("CENTER", f.ebButton, "CENTER", 2, 0);
	fo:SetText("v")
	f.ebButton:SetFontString(fo)
	f.ebButton:SetScript("OnClick", function() 
		if f.dropFrame:IsVisible() then f.dropFrame:Hide();
		else f.dropFrame:Show(); end;
		for k,v in pairs(lists) do
			if v ~= f then v.dropFrame:Hide(); 	end;
		end;
	end);

	--Add a frame () below the textbox
	f.dropFrame = CreateFrame("Frame", nil, parent, "InsetFrameTemplate");
	f.dropFrame:SetSize(dropFrameWidth, dropFrameHeight);
	f.dropFrame:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 30, 0)
	f.dropFrame:SetFrameStrata("TOOLTIP");	

	--place a scroll frame 
	local sTemplate = "UIPanelScrollFrameTemplate";	
	if select(4, GetBuildInfo()) >= 100100 then sTemplate = "ScrollFrameTemplate"; end

	f.sFrame = CreateFrame("ScrollFrame", nil, f.dropFrame, sTemplate)	
	f.sFrame:SetSize(dropFrameWidth - 45, dropFrameHeight - 20)
	f.sFrame:SetPoint("TOPLEFT", f.dropFrame, "TOPLEFT", 20, -15)

	--place a scrollchild in the scroll Frame
	f.sChild = CreateFrame("Frame");
	f.sChild:SetFrameStrata("TOOLTIP");	
	f.sChild:SetSize(dropFrameWidth, dropFrameHeight * 2)
	f.sFrame:SetScrollChild(f.sChild);
	--tinsert(lists, f);
	
	--Add some containers for text
	local t = {};
	for i = 1, maxEntries do
		--container for the text, needed for mouseover highlight
		t[i] = CreateFrame("Frame",nil,f.sChild);
		t[i]:SetSize(f.sChild:GetWidth(), 20);
		t[i]:SetPoint("TOPLEFT", 0, -(i-1) * 20);
		t[i].texture = t[i]:CreateTexture()
		t[i].texture:SetTexture("Interface/BUTTONS/WHITE8X8")
		t[i].texture:SetVertexColor(0, 0, 0, 0)		--Transparent
		--add the fontstring
		t[i].font = t[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		t[i].font:SetPoint("CENTER", t[i], "CENTER")
		t[i].font:SetTextColor(1, 1, 1, 1)			--White solid
		t[i].font:SetWidth(t[i]:GetWidth());
		t[i].font:SetJustifyH("LEFT");
		t[i].texture:SetAllPoints(t[i])
		t[i]:SetScript("OnEnter", function (self)
			--highlight by making a dark white background that is semitransparent
			self.texture:SetVertexColor(.4, .4, .4, .25)
		end)	
		t[i]:SetScript("OnLeave", function (self)
			--back to transparent
			self.texture:SetVertexColor(0, 0, 0, 0)
		end)
		t[i]:SetScript("OnMouseDown", function (self)
			--select and hide
			local t = self.font:GetText() or "";
			if t ~= "" then f:SetText(t); end;
			f.dropFrame:Hide();		
		end)
	end;
	f.dropFrame:Hide();	
	f:Show();	
	function list:SetList(list, sortFlag)
		--list:SetList(list[, sortFlag])	--if called with a list only the flag defaults to false
		if sortFlag then table.sort(list); end;
		--populates the droplist
		local i = 1;
		while i <= maxEntries do			--hide unused lines
			t[i].font:SetText("");
			t[i]:Hide();
			i = i + 1;
		end;
		i = 1;
		while i <= #list do		
			t[i].font:SetText(list[i]);		--Add all list entries
			t[i]:Show();					--show used lines
			i = i + 1;
			if i > maxEntries then break end;
		end;
		f:SetText(""); 
	end;	
	return f, list;
end;