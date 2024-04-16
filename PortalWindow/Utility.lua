local addon, ns = ...


function ns:colorString(c, str)
	local color = { ["red"] = "FF0000", ["green"]  = "00FF00", ["white"] = "FFFFFF", 
		["blue"] = "0000FF", ["orange"] = "CF8C5A"; ["yellow"] = "FFFF00" };
	if c == nil then return; end;
	if str == nil then str = "nil"; end;
	return string.format("|cff%s%s|r", color[c], str);
end;

function ns.setDesaturation(texture, desaturation)
	-- desaturation, nil = normal colors, 1 = desaturate (greyscale)
	if desaturation == true then desaturation = nil; end;
	if desaturation == false then desaturation = 1; end;
	local shaderSupported = texture:SetDesaturated(desaturation);
	if ( not shaderSupported ) then
		if ( desaturation ) then
			texture:SetVertexColor(0.5, 0.5, 0.5);
		else
			texture:SetVertexColor(1.0, 1.0, 1.0);
		end;		
	end;
end;

function ns:iniCompartmentFrame()
	if select(4, GetBuildInfo()) > 100000 then
		AddonCompartmentFrame:RegisterAddon({
			text = "Portal Window",
			icon = "Interface\\Icons\\achievement_guildperk_hastyhearth",
			notCheckable = true,
			registerForAnyClick = true,
			func = function(btn, arg1, arg2, checked, mouseButton)
				if mouseButton == "LeftButton" then
					ns:loadPortalWindow();
				elseif mouseButton == "RightButton" then			
					if ns.portalWindow then ns.portalWindow:ClearAllPoints(); ns.portalWindow:SetPoint("CENTER", UIParent, "CENTER"); end;
				end;
			end,
			funcOnEnter = function()
				GameTooltip:SetOwner(AddonCompartmentFrame, "ANCHOR_TOPRIGHT");
				GameTooltip:AddDoubleLine(ns:colorString("yellow", "Portal Window"), "v" .. C_AddOns.GetAddOnMetadata(addon, "Version"));
				GameTooltip:AddLine("\n" .. ns:colorString("orange", "Left Click") .. ns:colorString("green", " - Open Interface"));
				GameTooltip:AddLine(ns:colorString("orange", "Right Click") .. ns:colorString("green", " - Center Window"));	
				GameTooltip:AddLine(ns:colorString("orange", "/n//portw") .. ns:colorString("green", " - Open Interface\n"));
				GameTooltip:Show();
			end,
			funcOnLeave = function()
				GameTooltip:Hide();
			end,
		})
	end;
end;

SLASH_PORTALSERVER1 = "/portw"
SlashCmdList.PORTALSERVER = function()
	ns:loadPortalWindow();
end;