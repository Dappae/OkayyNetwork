local ui = 0
local loaded = false
local currentID = ''

function CreateUI(id, name)

	if ui == 0 then
		ui = CreateWebUI(0, 0, 0, 0, 5, 60)
		LoadWebFile(ui, "http://asset/kuz_UI/gui/ui.html")
		SetWebAlignment(ui, 0.0, 0.0)
		SetWebAnchors(ui, 0.0, 0.0, 1.0, 1.0)
		SetWebVisibility(ui, WEB_HIDDEN)
		currentID = id
		Delay(1000, function()
			CallRemoteEvent("KUI:MenuLoaded_" .. id)
			loaded = true
			AddPlayerChat("creating ui " .. name .. " = " .. id)
			ExecuteWebJS(ui, "OnCreate('"..name.."','"..id.."');")
		end)
	else
		DestroyUI()
	end
end
AddRemoteEvent("KUI:Create", CreateUI)

function ShowUI(id, bool)
	if ui ~= 0 then
		if currentID ~= '' and currentID ~= nil then
			if loaded then
				if bool then
					SetWebVisibility(ui, WEB_VISIBLE)
					SetIgnoreLookInput(true)
					ShowMouseCursor(true)
					SetInputMode(INPUT_GAMEANDUI)
				else
					SetWebVisibility(ui, WEB_HIDDEN)
					SetIgnoreLookInput(false)
					ShowMouseCursor(false)
					SetInputMode(INPUT_GAME)
				end
			else
				Delay(500, ShowUI, id, bool)
			end
		end
	end
end
AddRemoteEvent("KUI:Show", ShowUI)

AddEvent("OnKeyPress", function(key)
	if key == "Escape" then
		if ui ~= 0 then
			DestroyUI()
		end
	end
end)

function DestroyUI()
	if ui ~= 0 then
		CallRemoteEvent("KUI:Closed_" .. currentID)
		DestroyWebUI(ui)
		currentID = nil
		loaded = false
		ui = 0
	end
end
AddRemoteEvent("KUI:Close", DestroyUI)

function AddOption(id, title, description, button_text)
	if ui ~= 0 then
		Delay(500, InsertOption, id, title, description, button_text)
		
	end
end
AddRemoteEvent("KUI:AddOption", AddOption)

function InsertOption(id, title, description, button_text)
	if loaded then
		ExecuteWebJS(ui, "InsertOption('"..id.."','"..title.."','"..description.."','"..button_text.."');")
	else
		Delay(500, InsertOption, id, title, description, button_text)
	end
end

function OnOptionClick(ui_id, option)
	if ui_id ~= "" and ui_id ~= nil and currentID ~= nil and currentID ~= '' then
		CallRemoteEvent("KUI:OptionClick_" .. ui_id, option)
	end
end
AddEvent("KUI:OptionPressed", OnOptionClick)