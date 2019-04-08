-- See LICENSE for terms

-- most OnMsgs

local type = type
local table_sort = table.sort
local table_remove = table.remove
local FlushLogFile = FlushLogFile
local IsValid = IsValid
local Msg = Msg
local OnMsg = OnMsg
local CreateRealTimeThread = CreateRealTimeThread

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

--~ -- use this message to mess with the classdefs (before classes are built)
--~ function OnMsg.ClassesGenerate()
--~ end

do -- custom msgs
	local AddMsgToFunc = ChoGGi.ComFuncs.AddMsgToFunc
	AddMsgToFunc("BaseBuilding","GameInit","ChoGGi_SpawnedBaseBuilding")
	AddMsgToFunc("Drone","GameInit","ChoGGi_SpawnedDrone")
	AddMsgToFunc("PinnableObject","TogglePin","ChoGGi_TogglePinnableObject")

	AddMsgToFunc("AirProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducer","air_production")
	AddMsgToFunc("ElectricityProducer","CreateElectricityElement","ChoGGi_SpawnedProducer","electricity_production")
	AddMsgToFunc("WaterProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducer","water_production")
	AddMsgToFunc("SingleResourceProducer","Init","ChoGGi_SpawnedProducer","production_per_day")
end -- do

-- be too annoying to add templates to all of these manually
XMenuEntry.RolloverTemplate = "Rollover"
XMenuEntry.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])
XListItem.RolloverTemplate = "Rollover"
XListItem.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])

-- sure, lets have them appear under certain items (though i think mostly just happens from console, and I've changed that so I could remove this?)
XRolloverWindow.ZOrder = max_int

-- changed from 2000000
ConsoleLog.ZOrder = 2
Console.ZOrder = 3
-- changed from 10000000
XShortcutsHost.ZOrder = 4
-- make cheats menu look like older one (more gray, less white)
local dark_gray = -9868951
XMenuBar.Background = dark_gray
XMenuBar.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])
XPopupMenu.Background = dark_gray
XPopupMenu.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])
-- it sometimes does a jarring white background
XPopupMenu.DisabledBackground = dark_gray
-- darker gray
XPopupMenu.FocusedBackground = -11711669

TextStyles.DevMenuBar.TextColor = white

if not ChoGGi.UserSettings.EnableToolTips then
	ChoGGi_Text.RolloverTemplate = ""
	ChoGGi_TextList.RolloverTemplate = ""
	ChoGGi_MultiLineEdit.RolloverTemplate = ""
	ChoGGi_MoveControl.RolloverTemplate = ""
	ChoGGi_Buttons.RolloverTemplate = ""
	ChoGGi_Image.RolloverTemplate = ""
	ChoGGi_ComboButton.RolloverTemplate = ""
	ChoGGi_CheckButton.RolloverTemplate = ""
	ChoGGi_TextInput.RolloverTemplate = ""
	ChoGGi_List.RolloverTemplate = ""
	ChoGGi_ListItem.RolloverTemplate = ""
	ChoGGi_Dialog.RolloverTemplate = ""
	ChoGGi_DialogSection.RolloverTemplate = ""
	ChoGGi_Window.RolloverTemplate = ""
end

do -- ForbiddenShortcutKeys
	-- unforbid binding some keys (i left Enter and Menu, not sure what Menu is for? seems best to leave it)
	local f = ForbiddenShortcutKeys
	f.Lwin = nil
	f.Rwin = nil
	f.MouseL = nil
	f.MouseR = nil
	f.MouseM = nil
end -- do

-- use this message to do some processing to the already final classdefs (still before classes are built)
function OnMsg.ClassesPreprocess()
	local ChoGGi = ChoGGi

	-- stops crashing with certain missing pinned objects
	if ChoGGi.UserSettings.FixMissingModBuildings then
		local umc = UnpersistedMissingClass
		ChoGGi.ComFuncs.AddParentToClass(umc,"AutoAttachObject")
		ChoGGi.ComFuncs.AddParentToClass(umc,"PinnableObject")
		umc.entity = "ErrorAnimatedMesh"

		-- removes some spam from logs (might cause weirdness so just for me)
		if testing then
			local empty_func = empty_func
			umc.CanReserveResidence = empty_func
			umc.GetEntrance = empty_func
			umc.GetEntrancePoints = empty_func
			umc.GetUIStatusOverrideForWorkCommand = empty_func
			umc.HasFreeVisitSlots = empty_func
			umc.RefreshNightLightsState = empty_func
			umc.RemoveCommandCenter = empty_func
			umc.RemoveResident = empty_func
			umc.RemoveWorker = empty_func
			umc.SetIsNightLightPossible = empty_func
			umc.Unassign = empty_func
			umc.UpdateAttachedSigns = empty_func
		end
	end

end

-- where we can add new BuildingTemplates
-- use this message to make modifications to the built classes (before they are declared final)
--~ function OnMsg.ClassesPostprocess()
--~ end

do -- OnMsg ClassesBuilt/XTemplatesLoaded
	local PlaceObj = PlaceObj
	local function AddCheatsPane(xt,func)
		func(xt,"__template","sectionCheats")
		xt[#xt+1] = PlaceObj("XTemplateTemplate", {
			"__template", "sectionCheats",
		})
	end

--~ 	function OnMsg.XTemplatesLoaded()
	local function OnMsgXTemplates()
		local XTemplates = XTemplates
		local ChoGGi = ChoGGi
		local UserSettings = ChoGGi.UserSettings

		-- add some ids to make it easier to fiddle with selection panel
		for key,template in pairs(XTemplates) do
			if key:sub(1,7) == "section" then
				local inner = template[1]
				if inner and not inner.Id then
					inner.Id = "id" .. template.id .. "_ChoGGi"
				end
			end
		end
--~ 		XTemplates.sectionCheats

		-- add cheats section to stuff without it
		local func = ChoGGi.ComFuncs.RemoveXTemplateSections
		AddCheatsPane(XTemplates.ipAlienDigger[1],func)
		AddCheatsPane(XTemplates.ipAttackRover[1],func)
		AddCheatsPane(XTemplates.ipConstruction[1],func)
		AddCheatsPane(XTemplates.ipEffectDeposit[1],func)
		AddCheatsPane(XTemplates.ipFirefly[1],func)
		AddCheatsPane(XTemplates.ipGridConstruction[1],func)
		AddCheatsPane(XTemplates.ipLeak[1],func)
		AddCheatsPane(XTemplates.ipPillaredPipe[1],func)
		AddCheatsPane(XTemplates.ipResourcePile[1],func)
		AddCheatsPane(XTemplates.ipRogue[1],func)
		AddCheatsPane(XTemplates.ipShuttle[1],func)
		AddCheatsPane(XTemplates.ipSinkhole[1],func)
		AddCheatsPane(XTemplates.ipSwitch[1],func)
		AddCheatsPane(XTemplates.ipTerrainDeposit[1],func)
		-- and remove it from Resource Overview, though it is "removed" from the game now anyways...
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipResourceOverview[1],"__template","sectionCheats")

		-- no sense in firing the func without cheats pane enabled
		XTemplates.sectionCheats[1].__condition = function(parent, context)
			return config.BuildingInfopanelCheats and context:CreateCheatActions(parent)
		end
		-- remove all that spacing between buttons
		XTemplates.sectionCheats[1][1].LayoutHSpacing = 10

		-- add rollovers to cheats toolbar
		XTemplates.EditorToolbarButton[1].RolloverTemplate = "Rollover"

		-- left? right? who cares? I do... *&^%$#@$ designers
		if UserSettings.GUIDockSide then
			XTemplates.NewOverlayDlg[1].Dock = "right"
			XTemplates.SaveLoadContentWindow[1].Dock = "right"
			ChoGGi.ComFuncs.SetTableValue(XTemplates.SaveLoadContentWindow[1],"Dock","left","Dock","right")
			XTemplates.PhotoMode[1].Dock = "right"
		end

		-- change rollover max width
		if UserSettings.WiderRollovers then
			local roll = XTemplates.Rollover[1]
			local idx = table.find(roll,"Id","idContent")
			if idx then
				roll = roll[idx]
				idx = table.find(roll,"Id","idText")
				if idx then
					roll[idx].MaxWidth = UserSettings.WiderRollovers
				end
			end
		end

		-- added to stuff spawned with object spawner
		if XTemplates.ipChoGGi_Entity then
			XTemplates.ipChoGGi_Entity:delete()
		end

		PlaceObj("XTemplate", {
			group = "Infopanel Sections",
			id = "ipChoGGi_Entity",
			PlaceObj("XTemplateTemplate", {
				"__context_of_kind", "ChoGGi_BuildingEntityClass",
				"__template", "Infopanel",
			}, {

				PlaceObj("XTemplateTemplate", {
					"__template", "InfopanelButton",
					"RolloverTitle", Strings[302535920000682--[[Change Entity--]]],
					"RolloverHint", Translate(608042494285--[[<left_click> Activate--]]),
					"ContextUpdateOnOpen", false,
					"OnContextUpdate", function(self)
						self:SetRolloverText(Strings[302535920001151--[[Set Entity For %s--]]]:format(RetName(self.context)))
					end,
					"OnPress", function(self)
						if self.context.planning then
							ChoGGi.ComFuncs.EntitySpawner(self.context,true,7,true)
						else
							ChoGGi.ComFuncs.EntitySpawner(self.context,true,7)
						end
					end,
					"Icon", "UI/Icons/IPButtons/shuttle.tga",
				}),

				PlaceObj("XTemplateTemplate", {
					"__template", "InfopanelButton",
					"RolloverTitle", Translate(1000077--[[Rotate--]]),
					"RolloverText", Translate(312752058553--[[Rotate Building Left--]]),
					"RolloverHint", Translate(608042494285--[[<left_click> Activate--]]),
					"OnPress", function(self)
						self.context:Rotate()
						SelectionRemove(self.context)
						SelectObj(self.context)
					end,
					"Icon", "UI/Icons/IPButtons/automated_mode_on.tga",
				}),

				PlaceObj("XTemplateTemplate", {
					"__template", "InfopanelButton",
					"RolloverTitle", Strings[302535920000457--[[Anim State Set--]]],
					"RolloverHint", Translate(608042494285--[[<left_click> Activate--]]),
					"RolloverText", Strings[302535920000458--[[Make object dance on command.--]]],
					"ContextUpdateOnOpen", false,
					"OnPress", function(self)
						ChoGGi.ComFuncs.SetAnimState(self.context)
					end,
					"Icon", "UI/Icons/IPButtons/expedition.tga",
				}),

				PlaceObj("XTemplateTemplate", {
					"__template", "InfopanelButton",
					"RolloverTitle", Strings[302535920000129--[[Set--]]] .. " " .. Strings[302535920001184--[[Particles--]]],
					"RolloverHint", Translate(608042494285--[[<left_click> Activate--]]),
					"RolloverText", Strings[302535920001421--[[Shows a list of particles you can use on the selected obj.--]]],
					"OnPress", function(self)
						ChoGGi.ComFuncs.SetParticles(self.context)
					end,
					"Icon", "UI/Icons/IPButtons/status_effects.tga",
				}),

				PlaceObj("XTemplateTemplate", {
					"__template", "sectionCheats",
				}),
			}),
		})
	end

	-- called when new DLC is added (or a new game)
	OnMsg.XTemplatesLoaded = OnMsgXTemplates

	-- use this message to perform post-built actions on the final classes
	function OnMsg.ClassesBuilt()
		-- add HiddenX cat for Hidden items
		local bc = BuildCategories
		if ChoGGi.UserSettings.Building_hide_from_build_menu and not table.find(bc,"id","HiddenX") then
			bc[#bc+1] = {
				id = "HiddenX",
				name = Translate(1000155--[[Hidden--]]),
				image = "UI/Icons/bmc_placeholder.tga",
				highlight = "UI/Icons/bmc_placeholder_shine.tga",
			}
		end

		OnMsgXTemplates()
	end

end -- do

function OnMsg.ModsReloaded()
	local ChoGGi = ChoGGi
	local UserSettings = ChoGGi.UserSettings

	-- added this here, as it's early enough to load during the New Game Menu
	local Actions = ChoGGi.Temp.Actions
	if UserSettings.DisableECM then
		-- remove all my actions from ecm
		for i = #Actions, 1, -1 do
			local a = Actions[i]
			-- if it's a . than we haven't updated it yet
			if a.ActionId:sub(1,1) == "." then
				table_remove(Actions,i)
			end
		end
	else
		local c = #Actions

		c = c + 1
		Actions[c] = {
			ActionMenubar = "ECM.Debug",
			ActionName = Strings[302535920001074--[[Ged Presets Editor--]]],
			ActionId = ".Ged Presets Editor",
			ActionIcon = "CommonAssets/UI/Menu/folder.tga",
			OnActionEffect = "popup",
			ActionSortKey = "1Ged Presets Editor",
		}

		-- add preset menu items
		ClassDescendantsList("Preset", function(name, cls)
			if not name:find("ChoGGi") then
				c = c + 1
				Actions[c] = {
					ActionMenubar = "ECM.Debug.Ged Presets Editor",
					ActionName = name,
					ActionId = "." .. name,
					ActionIcon = cls.EditorIcon or "CommonAssets/UI/Menu/CollectionsEditor.tga",
					RolloverText = Strings[302535920000733--[[Open a preset in the editor.--]]],
					OnAction = function()
						OpenGedApp(g_Classes[name].GedEditor, Presets[name], {
							PresetClass = name,
							SingleFile = cls.SingleFile
						})
					end,
				}
			end
		end)

		-- add the defaults we skipped to my actions
		for i = 1, c do
			local a = Actions[i]
			-- if it's a . than we haven't updated it yet
			if a.ActionId:sub(1,1) == "." then
				a.ActionTranslate = false
				a.replace_matching_id = true
				a.ActionId = (a.ActionMenubar ~= "" and a.ActionMenubar or "ECM") .. a.ActionId
				a.ChoGGi_ECM = true
			end
		end

		-- show console log history
		if UserSettings.ConsoleToggleHistory then
			ShowConsoleLog(true)
		end

		if UserSettings.ConsoleHistoryWin then
			ChoGGi.ComFuncs.ShowConsoleLogWin(true)
		end

		-- dim that console bg
		if UserSettings.ConsoleDim then
			config.ConsoleDim = 1
		end

		-- build console buttons
		local dlgConsole = dlgConsole
		if dlgConsole and not dlgConsole.ChoGGi_MenuAdded then
			local edit = dlgConsole.idEdit

			-- add a context menu
			edit.OnKillFocus = ChoGGi_InputContextMenu.OnKillFocus
			edit.OnMouseButtonDown = ChoGGi_InputContextMenu.OnMouseButtonDown
			edit.RetContextList = ChoGGi_InputContextMenu.RetContextList

			-- removes comments from code, and adds a space to each newline, so pasting multi line works
			local XEditEditOperation = XEdit.EditOperation
			local StripComments = ChoGGi.ComFuncs.StripComments
			function edit:EditOperation(insert_text, is_undo_redo, cursor_to_text_start,...)
				if type(insert_text) == "string" then
					insert_text = StripComments(insert_text)
					insert_text = insert_text:gsub("\n"," \n")
				end
				return XEditEditOperation(self,insert_text, is_undo_redo, cursor_to_text_start,...)
			end

			edit.RolloverTemplate = "Rollover"
			edit.RolloverTitle = Strings[302535920001073--[[Console--]]] .. " " .. Translate(487939677892--[[Help--]])
			-- add tooltip
			edit.RolloverText = Strings[302535920001440--[["~obj opens object in examine dlg.
~~obj opens object's attachments in examine dlg.

&handle examines object with that handle.

@GetMissionSponsor prints file name and line number of function.

@@EntityData prints type(EntityData).

%""UI/Vignette.tga"" opens image in image viewer.

$123 or $EffectDeposit.display_name prints translated string.

""*r Sleep(1000) print(""sleeping"")"" to wrap in a real time thread (or *g or *m).

!UICity.labels.TerrainDeposit[1] move camera and select obj.

s = SelectedObj, c() = GetTerrainCursor(), restart() = quit(""restart"")"--]]]
			edit.Hint = Strings[302535920001439--[["~obj, @func, @@type, $id, %image, *r/*g/*m threads. Hover mouse for more info."--]]]

			dlgConsole.ChoGGi_MenuAdded = true
			-- and buttons
			ChoGGi.ConsoleFuncs.ConsoleControls(dlgConsole)
		end

		-- show cheat pane in selection panel
		if UserSettings.InfopanelCheats then
			config.BuildingInfopanelCheats = true
		end

		-- remove some uselessish Cheats to clear up space
		if UserSettings.CleanupCheatsInfoPane then
			ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
		end

		-- cheats menu fun
		local XShortcutsTarget = XShortcutsTarget
		if XShortcutsTarget then

			for i = 1, #XShortcutsTarget do
				local item = XShortcutsTarget[i]
				-- yeah... i don't need the menu taking up the whole width of my screen
				item:SetHAlign("left")

				-- add some ids for easier selection later on
				if item:IsKindOf("XMenuBar") then
					XShortcutsTarget.idMenuBar = item
				elseif item:IsKindOf("XWindow") then
					XShortcutsTarget.idToolbar = item
					break
				end
			end

			-- add a hint about rightclicking
			if UserSettings.EnableToolTips then
				local toolbar = XShortcutsTarget.idMenuBar
				toolbar:SetRolloverTemplate("Rollover")
				toolbar:SetRolloverTitle(Translate(126095410863--[[Info--]]))
				toolbar:SetRolloverText(Strings[302535920000503--[[Right-click an item/submenu to add/remove it from the quickbar.--]]])
				toolbar:SetRolloverHint(Strings[302535920001441--[["<left_click> Activate, <right_click> Add/Remove"--]]])
			end

			-- always show menu on my computer
			if UserSettings.ShowCheatsMenu or testing then
				XShortcutsTarget:SetVisible(true)
			end

			-- that info text about right-clicking expands the menu instead of just hiding or something
			for i = 1, #XShortcutsTarget.idToolbar do
				if XShortcutsTarget.idToolbar[i]:IsKindOf("XText") then
					XShortcutsTarget.idToolbar[i]:delete()
				end
			end

			-- add a little spacer to the top of cheats menu you can drag around
			ChoGGi.ComFuncs.DraggableCheatsMenu(
				UserSettings.DraggableCheatsMenu
			)
		end

	end -- DisableECM

	local BuildingTechRequirements = BuildingTechRequirements
	local BuildingTemplates = BuildingTemplates
	for id,bld in pairs(BuildingTemplates) do

		-- remove sponsor limits on buildings
		if UserSettings.SponsorBuildingLimits then
			-- set each status to false if it isn't
			for i = 1, 3 do
				local str = "sponsor_status" .. i
				local status = bld[str]
				if status ~= false then
					bld["sponsor_status" .. i .. "_ChoGGi_orig"] = status
					bld[str] = false
				end
			end

			local name = id
			if name:find("RC") and name:find("Building") then
				name = name:gsub("Building","")
			end
			local idx = table.find(BuildingTechRequirements[id],"check_supply",name)
			if idx then
				table_remove(BuildingTechRequirements[id],idx)
			end
		end

		-- make hidden buildings visible
		if UserSettings.Building_hide_from_build_menu then
			if bld.id ~= "LifesupportSwitch" and bld.id ~= "ElectricitySwitch" then
				bld.hide_from_build_menu_ChoGGi = bld.hide_from_build_menu
				bld.hide_from_build_menu = false
			end
			if bld.group == "Hidden" and bld.id ~= "RocketLandingSite" and bld.id ~= "ForeignTradeRocket" then
				bld.build_category = "HiddenX"
			end
		end

		-- wonder building limit
		if UserSettings.Building_wonder then
			bld.wonder = nil
		end

	end

	-- unlock buildings that cannot rotate
	if UserSettings.RotateDuringPlacement then
		local buildings = ClassTemplates.Building
		for _,bld in pairs(buildings) do
			if bld.can_rotate_during_placement == false then
				bld.can_rotate_during_placement_ChoGGi_orig = true
				bld.can_rotate_during_placement = true
			end
		end
	end

	-- print any mod error msgs in console
	local log = ModMessageLog
	local startup = ChoGGi.Temp.StartupMsgs
	for i = 1, #log do
		local msg = log[i]
		if msg:find("Error loading") then
			startup[#startup+1] = msg
		end
	end

end -- ModsReloaded

-- earliest on-ground objects are loaded?
--~ function OnMsg.PersistLoad()
--~ end

function OnMsg.PersistPostLoad()
	if ChoGGi.UserSettings.FixMissingModBuildings then
		-- [LUA ERROR] Mars/Lua/Construction.lua:860: attempt to index a boolean value (global 'ControllerMarkers')
		if type(ControllerMarkers) == "boolean" then
			ControllerMarkers = {}
		end

		-- [LUA ERROR] Mars/Lua/Heat.lua:65: attempt to call a nil value (method 'ApplyForm')
		local s_Heaters = s_Heaters or {}
		for obj in pairs(s_Heaters) do
			if obj:IsKindOf("UnpersistedMissingClass") then
				s_Heaters[obj] = nil
			end
		end

		local printit = ChoGGi.UserSettings.FixMissingModBuildingsLog

		-- GetFreeSpace,GetFreeLivingSpace,GetFreeWorkplaces,GetFreeWorkplacesAround
		local labels = UICity.labels or empty_table
		for label_id,label in pairs(labels) do
			if label_id ~= "Consts" then
				for i = #label, 1, -1 do
					local obj = label[i]
					if obj:IsKindOf("UnpersistedMissingClass") then
						if printit then
							print(Strings[302535920001401--[["Removed missing mod building from %s: %s, entity: %s, handle: %s"--]]]:format(label_id,RetName(obj),obj:GetEntity(),obj.handle))
						end
						obj:delete()
						table_remove(label,i)
					end
				end
			end
		end

	end -- if FixMissingModBuildings
end

-- for instant build
function OnMsg.BuildingPlaced(obj)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end --OnMsg

do -- ConstructionSitePlaced
	local function QuickBuild(sites)
		for i = 1, #sites do
			local site = sites[i]
			if not site.construction_group or site.construction_group[1] == site then
				site:Complete("quick_build")
			end
		end
	end

	-- regular build
	function OnMsg.ConstructionSitePlaced(obj)
		local ChoGGi = ChoGGi
		if obj:IsKindOf("Building") then
			ChoGGi.Temp.LastPlacedObject = obj
		end

		if ChoGGi.UserSettings.Building_instant_build then
			-- i do it this way instead of using .instant_build so domes don't screw up
			CreateRealTimeThread(function()
				Sleep(100)
				local labels = UICity.labels
				QuickBuild(labels.ConstructionSite or "")
				QuickBuild(labels.ConstructionSiteWithHeightSurfaces or "")
			end)
		end
	end --OnMsg

end -- do

-- make sure they use with our new values
function OnMsg.ChoGGi_SpawnedProducer(obj,prod_type)
	local prod = ChoGGi.UserSettings.BuildingSettings[obj.template_name]
	if prod and prod.production then
		obj[prod_type] = prod.production
	end
end

function OnMsg.ChoGGi_SpawnedDrone(obj)
	local UserSettings = ChoGGi.UserSettings
	if UserSettings.GravityDrone then
		obj:SetGravity(UserSettings.GravityDrone)
	end
	if UserSettings.SpeedDrone then
		obj:SetMoveSpeed(UserSettings.SpeedDrone)
	end
end


-- some upgrades change amounts, so reset them to ours
function OnMsg.BuildingUpgraded(obj)
	if obj:IsKindOf("ElectricityProducer") then
		Msg("ChoGGi_SpawnedProducer",obj,"electricity_production")
	elseif obj:IsKindOf("AirProducer") then
		Msg("ChoGGi_SpawnedProducer",obj,"air_production")
	elseif obj:IsKindOf("WaterProducer") then
		Msg("ChoGGi_SpawnedProducer",obj,"water_production")
	elseif obj:IsKindOf("SingleResourceProducer") then
		Msg("ChoGGi_SpawnedProducer",obj,"production_per_day")
	else
		-- do we want to check id for upgrades that don't change? seems too much like work
		Msg("ChoGGi_SpawnedBaseBuilding",obj)
	end
end

-- :GameInit() (Msg.BuildingInit only does Building, not BaseBuilding)
function OnMsg.ChoGGi_SpawnedBaseBuilding(obj)
	local ChoGGi = ChoGGi
	local UserSettings = ChoGGi.UserSettings

	if obj:IsKindOfClasses("ConstructionSite", "ConstructionSiteWithHeightSurfaces") then
		return
	end

	-- not working code from when tried to have passages placed in entrances

--~ 	-- if it's a fancy dome then we allow building in the removed entrances
--~ 	if obj:IsKindOf("Dome") then
--~ 		local id_start, id_end = obj:GetAllSpots(obj:GetState())
--~ 		for i = id_start, id_end do
--~ 			if obj:GetSpotName(i) == "Entrance" or obj:GetSpotAnnotation(i) == "att,DomeRoad_04,show" then
--~ 				print(111)
--~ 			end
--~ 		end
--~ 	end

	if UserSettings.CommandCenterMaxRadius and obj:IsKindOf("DroneHub") then
		-- we set it from the func itself
		obj:SetWorkRadius()

	elseif UserSettings.ServiceWorkplaceFoodStorage and obj:IsKindOfClasses("Grocery","Diner") then
		-- for some reason InitConsumptionRequest always adds 5 to it
		local storedv = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage - (5 * ChoGGi.Consts.ResourceScale)
		obj.consumption_stored_resources = storedv
		obj.consumption_max_storage = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage

	elseif UserSettings.RocketMaxExportAmount and obj:IsKindOf("SupplyRocket") then
		obj.max_export_storage = UserSettings.RocketMaxExportAmount

	elseif obj:IsKindOf("BaseRover") then
		if UserSettings.RCTransportStorageCapacity and obj:IsKindOf("RCTransport") then
			obj.max_shared_storage = UserSettings.RCTransportStorageCapacity
		elseif UserSettings.RCRoverMaxRadius and obj:IsKindOf("RCRover") then
			-- I override the func so no need to send a value here
			obj:SetWorkRadius()
		end

		-- applied to all rovers
		if UserSettings.SpeedRC then
			obj:SetMoveSpeed(UserSettings.SpeedRC)
		end
		if UserSettings.GravityRC then
			obj:SetGravity(UserSettings.GravityRC)
		end

	elseif obj:IsKindOf("CargoShuttle") then
		if UserSettings.StorageShuttle then
			obj.max_shared_storage = UserSettings.StorageShuttle
		end
		if UserSettings.SpeedShuttle then
			obj.move_speed = UserSettings.SpeedShuttle
		end

	elseif UserSettings.StorageUniversalDepot and obj:GetEntity() == "StorageDepot" and obj:IsKindOf("UniversalStorageDepot") then
		obj.max_storage_per_resource = UserSettings.StorageUniversalDepot

	elseif UserSettings.StorageMechanizedDepot and obj:IsKindOf("MechanizedDepot") then
		obj.max_storage_per_resource = UserSettings.StorageMechanizedDepot

	elseif UserSettings.StorageWasteDepot and obj:IsKindOf("WasteRockDumpSite") then
		obj.max_amount_WasteRock = UserSettings.StorageWasteDepot
		if obj:GetStoredAmount() < 0 then
			obj:CheatEmpty()
			obj:CheatFill()
		end

	elseif UserSettings.ShuttleHubFuelStorage and obj.class:find("ShuttleHub") then
		obj.consumption_max_storage = UserSettings.ShuttleHubFuelStorage

	elseif UserSettings.SchoolTrainAll and obj.class:find("School") then
		for i = 1, #ChoGGi.Tables.PositiveTraits do
			obj:SetTrait(i,ChoGGi.Tables.PositiveTraits[i])
		end

	elseif UserSettings.SanatoriumCureAll and obj.class:find("Sanatorium") then
		for i = 1, #ChoGGi.Tables.NegativeTraits do
			obj:SetTrait(i,ChoGGi.Tables.NegativeTraits[i])
		end

	end -- end of elseif

	if UserSettings.StorageMechanizedDepotsTemp and obj:IsKindOf("ResourceStockpileLR") and obj.parent:IsKindOf("MechanizedDepot") then
		-- attached temporary resource depots
		ChoGGi.ComFuncs.SetMechanizedDepotTempAmount(obj.parent)
	end

	-- if an inside building is placed outside of dome, attach it to nearest dome (if there is one)
	if obj:IsKindOfClasses("Residence","Workplace","SpireBase") then
		-- seems to need a delay in DA
		CreateRealTimeThread(function()
			Sleep(100)
			ChoGGi.ComFuncs.AttachToNearestDome(obj)
		end)
	end

	if UserSettings.StorageOtherDepot then
		if (obj:GetEntity() ~= "StorageDepot" and obj:IsKindOf("UniversalStorageDepot")) or obj:IsKindOf("MysteryDepot") then
			obj.max_storage_per_resource = UserSettings.StorageOtherDepot
		elseif UserSettings.StorageOtherDepot and obj:IsKindOf("BlackCubeDumpSite") then
			obj.max_amount_BlackCube = UserSettings.StorageOtherDepot
		end
	end

	if UserSettings.InsideBuildingsNoMaintenance and obj:IsKindOf("Constructable") then
		obj.ChoGGi_InsideBuildingsNoMaintenance = true
		obj.maintenance_build_up_per_hr = -10000
	end

	if UserSettings.RemoveMaintenanceBuildUp and obj:IsKindOf("RequiresMaintenance") then
		obj.ChoGGi_RemoveMaintenanceBuildUp = true
		obj.maintenance_build_up_per_hr = -10000
	end

	-- saved building settings
	local bs = UserSettings.BuildingSettings[obj.template_name]
	if type(bs) == "table" then
		if next(bs) then
			-- saved settings for capacity, shuttles
			if bs.capacity then
				if obj.base_capacity then
					obj.capacity = bs.capacity
				elseif obj.base_air_capacity then
					obj.air_capacity = bs.capacity
				elseif obj.base_water_capacity then
					obj.water_capacity = bs.capacity
				elseif obj.base_max_shuttles then
					obj.max_shuttles = bs.capacity
				end
			end
			-- max visitors
			if bs.visitors and obj.base_max_visitors then
				obj.max_visitors = bs.visitors
			end
			-- max workers
			if bs.workers then
				obj.max_workers = bs.workers
			end
			-- no power needed
			if bs.nopower then
				ChoGGi.ComFuncs.RemoveBuildingElecConsump(obj)
			end
			if bs.noair then
				ChoGGi.ComFuncs.RemoveBuildingAirConsump(obj)
			end
			if bs.nowater then
				ChoGGi.ComFuncs.RemoveBuildingWaterConsump(obj)
			end
			-- large protect_range for defence buildings
			if bs.protect_range then
				obj.protect_range = bs.protect_range
				obj.shoot_range = bs.protect_range * guim
			end
			-- fully auto building
			if bs.auto_performance then
				obj.max_workers = 0
				obj.automation = 1
				obj.auto_performance = bs.auto_performance
			end
			-- legacy setting
			if bs.performance then
				obj.max_workers = 0
				obj.automation = 1
				obj.auto_performance = bs.performance
			end
			-- just perf boost
			if bs.performance_notauto then
				obj.performance = bs.performance_notauto
			end
			-- space ele export amount
			if bs.max_export_storage then
				obj.max_export_storage = bs.max_export_storage
			end
			-- space ele import amount
			if bs.cargo_capacity then
				obj.cargo_capacity = bs.cargo_capacity
			end
			-- service comforts
			if bs.service_stats and next(bs.service_stats) then
				ChoGGi.ComFuncs.UpdateServiceComfortBld(obj,bs.service_stats)
			end
			-- training points
			if bs.evaluation_points then
				obj.evaluation_points = bs.evaluation_points
			end
			-- need to wait a sec for the grid objects to be created
			CreateRealTimeThread(function()
				-- dis/charge rates
				local prod_type = obj.GetStoredAir and "air" or obj.GetStoredWater and "water" or obj.GetStoredPower and "electricity"
				while not obj[prod_type] do
					Sleep(100)
				end
				if bs.charge then
					obj[prod_type].max_charge = bs.charge
					obj["max_" .. prod_type .. "_charge"] = bs.charge
				end
				if bs.discharge then
					obj[prod_type].max_discharge = bs.discharge
					obj["max_" .. prod_type .. "_discharge"] = bs.discharge
				end
			end)

		else
			-- empty table so remove
			UserSettings.BuildingSettings[obj.template_name] = nil
		end
	end

end --OnMsg

function OnMsg.Demolished(obj)
	local UICity = UICity
	-- update our list of working domes for AttachToNearestDome (though I wonder why this isn't already a label)
	if obj.achievement == "FirstDome" then
		local UICity = obj.city or UICity
		UICity.labels.Domes_Working = nil
		UICity:InitEmptyLabel("Domes_Working")

		local domes = UICity.labels.Dome or ""
		local c = #UICity.labels.Domes_Working
		for i = 1, #domes do
			c = c + 1
			UICity.labels.Domes_Working[c] = domes[i]
		end
	end
end --OnMsg

do -- ColonistCreated
	local function ColonistCreated(obj,skip)
		local UserSettings = ChoGGi.UserSettings

		if UserSettings.GravityColonist then
			obj:SetGravity(UserSettings.GravityColonist)
		end
		if UserSettings.NewColonistGender then
			ChoGGi.ComFuncs.ColonistUpdateGender(obj,UserSettings.NewColonistGender)
		end
		if UserSettings.NewColonistAge then
			ChoGGi.ComFuncs.ColonistUpdateAge(obj,UserSettings.NewColonistAge)
		end
		-- children don't have spec models so they get black cube
		if UserSettings.NewColonistSpecialization and not skip then
			ChoGGi.ComFuncs.ColonistUpdateSpecialization(obj,UserSettings.NewColonistSpecialization)
		end
		if UserSettings.NewColonistRace then
			ChoGGi.ComFuncs.ColonistUpdateRace(obj,UserSettings.NewColonistRace)
		end
		if UserSettings.NewColonistTraits then
			ChoGGi.ComFuncs.ColonistUpdateTraits(obj,true,UserSettings.NewColonistTraits)
		end
		if UserSettings.SpeedColonist then
			obj:SetMoveSpeed(UserSettings.SpeedColonist)
		end
		if UserSettings.DeathAgeColonist then
			obj.death_age = UserSettings.DeathAgeColonist
		end

	end

	OnMsg.ColonistArrived = ColonistCreated
	OnMsg.ColonistBorn = ColonistCreated
end -- do

function OnMsg.SelectionAdded(obj)
	-- update selection shortcut
	s = obj
	-- update last placed (or selected)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end

-- remove selected obj when nothing selected
function OnMsg.SelectionRemoved()
	s = false
end

-- const.Scale.sols is 720 000 ticks (GameTime)
function OnMsg.NewDay() -- NewSol...
	local ChoGGi = ChoGGi

	-- remove any closed examine dialogs from the list
	local g_ExamineDlgs = g_ExamineDlgs or empty_table
	for obj,dlg in pairs(g_ExamineDlgs) do
		if dlg.window_state == "destroying" then
			g_ExamineDlgs[obj] = nil
		end
	end

	-- sorts cc list by dist to building
	if ChoGGi.UserSettings.SortCommandCenterDist then
		local objs = UICity.labels.Building or ""
		for i = 1, #objs do
			local obj = objs[i]
			-- no sense in doing it with only one center
			if #obj.command_centers > 1 then
				table_sort(obj.command_centers,function(a,b)
					if IsValid(a) and IsValid(b) then
						return obj:GetDist2D(a) < obj:GetDist2D(b)
					end
				end)
			end
		end
	end

	-- dump log to disk
	if ChoGGi.UserSettings.FlushLog then
		FlushLogFile()
	end

	-- loop through and remove any missing popups
	local popups = ChoGGi.Temp.MsgPopups or ""
	for i = #popups, 1, -1 do
		local popup = popups[i]
		if not popup:IsVisible() then
			popup:delete()
			table_remove(popups,i)
		end
	end
end

-- const.Scale.hours is 30 000 ticks (GameTime)
function OnMsg.NewHour()
	local ChoGGi = ChoGGi

	-- make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
	if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
		local labels = UICity.labels

		-- Hey. Do I preach at you when you're lying stoned in the gutter? No!
		local prods = labels.ResourceProducer or ""
		for i = 1, #prods do
			local prod = prods[i]
			ChoGGi.ComFuncs.FuckingDrones(prod:GetProducerObj())
			if prod.wasterock_producer then
				ChoGGi.ComFuncs.FuckingDrones(prod.wasterock_producer)
			end
		end

		prods = labels.BlackCubeStockpiles or ""
		for i = 1, #prods do
			ChoGGi.ComFuncs.FuckingDrones(prods[i])
		end

	end

	-- pathing? pathing in domes works great... watch out for that invisible wall!
	-- update: seems like this is an issue from one of those smarter work ai mods
	if ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings then
		ChoGGi.ComFuncs.ResetHumanCentipedes()
	end

	-- some types of crashing won't allow SM to gracefully close and leave a log/minidump as the devs envisioned... No surprise to anyone who's ever done any sort of debugging before.
	if ChoGGi.UserSettings.FlushLogConstantly then
		FlushLogFile()
	end
end

-- const.MinuteDuration is 500 ticks (GameTime)
--~ OnMsg.NewMinute = FlushLogFile
--~ function OnMsg.NewMinute()
--~ 	FlushLogFile()
--~ end

function OnMsg.ResearchQueueChange(city, tech_id)
	if ChoGGi.UserSettings.InstantResearch then
		CreateRealTimeThread(function()
			Sleep(100)
			GrantResearchPoints(city.tech_status[tech_id].cost)
			-- updates the researchdlg by toggling it.
			if GetDialog("ResearchDlg") then
				CloseDialog("ResearchDlg")
				OpenDialog("ResearchDlg")
			end
		end)
	end
end

-- if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
	local ChoGGi = ChoGGi
	if ChoGGi.UserSettings.ShowMysteryMsgs then
		MsgPopup(
			ChoGGi.Tables.Mystery[UICity.mystery_id].name .. ": "
				.. Strings[302535920000729--[[You've started a mystery!--]]],
			Translate(3486--[[Mystery--]])
		)
	end
end
function OnMsg.MysteryChosen()
	local ChoGGi = ChoGGi
	if ChoGGi.UserSettings.ShowMysteryMsgs then
		MsgPopup(
			ChoGGi.Tables.Mystery[UICity.mystery_id].name .. ": "
				.. Strings[302535920000730--[[You've chosen a mystery!--]]],
			Translate(3486--[[Mystery--]])
		)
	end
end
function OnMsg.MysteryEnd(outcome)
	local ChoGGi = ChoGGi
	if ChoGGi.UserSettings.ShowMysteryMsgs then
		MsgPopup(
			ChoGGi.Tables.Mystery[UICity.mystery_id].name .. ": "
				.. tostring(outcome),
			Translate(3486--[[Mystery--]])
		)
	end
end

-- fired when cheats menu is toggled
function OnMsg.DevMenuVisible(visible)
	if visible then
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			ChoGGi.ComFuncs.SetCheatsMenuPos()
		end)
	end
end

local once_ApplicationQuit
function OnMsg.ApplicationQuit()
	if once_ApplicationQuit then
		return
	end
	once_ApplicationQuit = true

	-- from GedSocket.lua
	local desktop = terminal.desktop
	for i = #desktop, 1, -1 do
		local d = desktop[i]
		if d:IsKindOf("GedApp") then
			d:Close()
		end
	end

	local ChoGGi = ChoGGi

	-- resetting settings?
	if ChoGGi.Temp.ResetECMSettings or testing then
		return
	end

	-- console window settings
	local dlg = dlgChoGGi_ConsoleLogWin
	if dlg then
		ChoGGi.UserSettings.ConsoleLogWin_Pos = dlg:GetPos()
		ChoGGi.UserSettings.ConsoleLogWin_Size = dlg:GetSize()
	end

	-- save menu pos
	if ChoGGi.UserSettings.KeepCheatsMenuPosition then
		ChoGGi.UserSettings.KeepCheatsMenuPosition = XShortcutsTarget:GetPos()
	end

	-- blacklist something resets this log
	if blacklist then
		ChoGGi.UserSettings.history_log = LocalStorage.history_log
	end

	-- save any unsaved settings on exit
	ChoGGi.SettingFuncs.WriteSettings()
end

function OnMsg.ChoGGi_TogglePinnableObject(obj)
	local UnpinObjects = ChoGGi.UserSettings.UnpinObjects
	if type(UnpinObjects) == "table" and next(UnpinObjects) then
		for i = 1, #UnpinObjects do
			if obj:IsKindOf(UnpinObjects[i]) and obj:IsPinned() then
				obj:TogglePin()
				break
			end
		end
	end
end

-- hidden milestones
function OnMsg.ChoGGi_DaddysLittleHitler()
	local MilestoneCompleted = MilestoneCompleted
	PlaceObj("Milestone", {
		base_score = 0,
		display_name = Strings[302535920000731--[[Deutsche Gesellschaft für Rassenhygiene--]]],
		group = "Default",
		id = "DaddysLittleHitler"
	})
	if not MilestoneCompleted.DaddysLittleHitler then
		MilestoneCompleted.DaddysLittleHitler = 3025359200000
	end
end

function OnMsg.ChoGGi_Childkiller()
	local MilestoneCompleted = MilestoneCompleted
	PlaceObj("Milestone", {
		base_score = 0,
		display_name = Strings[302535920000732--[[Childkiller (You evil, evil person.)--]]],
		group = "Default",
		id = "Childkiller"
	})
	if not MilestoneCompleted.Childkiller then
		MilestoneCompleted.Childkiller = 479000000
	end
end

-- show how long loading takes
function OnMsg.ChangeMap()
	if testing or ChoGGi.UserSettings.ShowStartupTicks then
		ChoGGi.Temp.StartupTicks = GetPreciseTicks()
	end
end

do -- LoadGame/CityStart
	local function SetMissionBonuses(UserSettings,Presets,preset,which,Func)
		local list = Presets[preset].Default or ""
		for i = 1, #list do
			local item = list[i]
			if UserSettings[which .. item.id] then
				Func(item.id)
			end
		end
	end

	-- saved game is loaded
	function OnMsg.LoadGame()
		ChoGGi.Temp.IsChoGGiMsgLoaded = false
		Msg("ChoGGi_Loaded")
	end
	-- for new games
	function OnMsg.CityStart()
		local ChoGGi = ChoGGi
		ChoGGi.Temp.IsChoGGiMsgLoaded = false
		-- reset my mystery msgs to hidden
		ChoGGi.UserSettings.ShowMysteryMsgs = nil
		Msg("ChoGGi_Loaded")
	end

	function OnMsg.ChoGGi_Loaded()
		local UICity = UICity
		--for new games
		if not UICity then
			return
		end

		-- a place to store per-game values
		if not UICity.ChoGGi then
			UICity.ChoGGi = {}
		end

		local ChoGGi = ChoGGi

		-- so ChoGGi_Loaded gets fired only every load, rather than also everytime we save
		if ChoGGi.Temp.IsChoGGiMsgLoaded == true then
			return
		end
		ChoGGi.Temp.IsChoGGiMsgLoaded = true

		local UserSettings = ChoGGi.UserSettings
		local g_Classes = g_Classes
		local const = const
		local BuildMenuPrerequisiteOverrides = BuildMenuPrerequisiteOverrides
		local Presets = Presets
		local hr = hr

		-- late enough that I can set g_Consts.
		ChoGGi.SettingFuncs.SetConstsToSaved()

		-- needed for DroneResourceCarryAmount?
		UpdateDroneResourceUnits()

		-- clear out Temp settings
		ChoGGi.Temp.UnitPathingHandles = {}

		-- not needed, removing from old saves, so people don't notice them
		UICity.labels.ChoGGi_GridElements = nil
		UICity.labels.ChoGGi_LifeSupportGridElement = nil
		UICity.labels.ChoGGi_ElectricityGridElement = nil
		-- re-binding is now an in-game thing, so keys are just defaults
		UserSettings.KeyBindings = nil

		SetMissionBonuses(UserSettings,Presets,"MissionSponsorPreset","Sponsor",ChoGGi.ComFuncs.SetSponsorBonuses)
		SetMissionBonuses(UserSettings,Presets,"CommanderProfilePreset","Commander",ChoGGi.ComFuncs.SetCommanderBonuses)




---------------------do the above stuff before the below stuff




		if UserSettings.mediumGameSpeed then
			const.mediumGameSpeed = UserSettings.mediumGameSpeed
		end
		if UserSettings.fastGameSpeed then
			const.fastGameSpeed = UserSettings.fastGameSpeed
		end

		-- make hidden buildings visible
		if UserSettings.Building_hide_from_build_menu then
			local bmpo = BuildMenuPrerequisiteOverrides
			for key,value in pairs(bmpo) do
				if value == "hide" then
					bmpo[key] = true
				end
			end
			bmpo.StorageMysteryResource = true
			bmpo.MechanizedDepotMysteryResource = true
		end

		-- show all traits in trainable popup
		if UserSettings.SanatoriumSchoolShowAllTraits then
			g_SchoolTraits = ChoGGi.Tables.PositiveTraits
			g_SanatoriumTraits = ChoGGi.Tables.NegativeTraits
		end

		-- all yours XxUnkn0wnxX
		if not blacklist then
			local autoexec = ChoGGi.scripts .. "/autoexec.lua"
			if ChoGGi.ComFuncs.FileExists(autoexec) then
				print("ECM auto-executing: ",ConvertToOSPath(autoexec))
				dofile(autoexec)
			end
		end

		-- bloody hint popups
		if ChoGGi.UserSettings.DisableHints then
			mapdata.DisableHints = true
			HintsEnabled = false
		end

		-- show completed hidden milestones
		if UICity.ChoGGi.DaddysLittleHitler then
			PlaceObj("Milestone", {
				base_score = 0,
				display_name = Strings[302535920000731--[[Deutsche Gesellschaft für Rassenhygiene--]]],
				group = "Default",
				id = "DaddysLittleHitler"
			})
			if not MilestoneCompleted.DaddysLittleHitler then
				MilestoneCompleted.DaddysLittleHitler = 3025359200000 -- hitler's birthday
			end
		end
		if UICity.ChoGGi.Childkiller then
			PlaceObj("Milestone", {
				base_score = 0,
				display_name = Strings[302535920000732--[[Childkiller (You evil, evil person.)--]]],
				group = "Default",
				id = "Childkiller"
			})
			--it doesn't hurt
			if not MilestoneCompleted.Childkiller then
				MilestoneCompleted.Childkiller = 479000000 -- 666
			end
		end

		--add custom lightmodel
		local lm = LightmodelPresets
		if type(lm.ChoGGi_Custom and lm.ChoGGi_Custom.delete) == "function" then
			lm.ChoGGi_Custom:delete()
		end

		-- we have to copy the table, so :new doesn't replace my saved settings
		local temp_lm
		if UserSettings.LightmodelCustom then
			temp_lm = table.copy(UserSettings.LightmodelCustom)
		else
			temp_lm = table.copy(ChoGGi.Consts.LightmodelCustom)
		end
		lm.ChoGGi_Custom = LightmodelPreset:new(temp_lm)

		-- if there's a lightmodel name saved
		if UserSettings.Lightmodel then
			SetLightmodelOverride(1,UserSettings.Lightmodel)
		end

		--long arsed cables
		if UserSettings.UnlimitedConnectionLength then
			g_Classes.GridConstructionController.max_hex_distance_to_allow_build = 1000
			const.PassageConstructionGroupMaxSize = 1000
		end

		-- on by default, you know all them martian trees (might make a cpu difference, probably not)
		hr.TreeWind = 0

		if UserSettings.DisableTextureCompression then
			-- uses more vram (1 toggles it, not sure what 0 does...)
			hr.TR_ToggleTextureCompression = 1
		end

		-- render settings
		hr.ShadowmapSize = UserSettings.ShadowmapSize or hr.ShadowmapSize
		hr.DTM_VideoMemory = UserSettings.VideoMemory or hr.DTM_VideoMemory
		hr.TR_MaxChunks = UserSettings.TerrainDetail or hr.TR_MaxChunks
		hr.LightsRadiusModifier = UserSettings.LightsRadius or hr.LightsRadiusModifier

		if UserSettings.HigherRenderDist then
			-- lot of lag for some small rocks in distance
			-- hr.AutoFadeDistanceScale = 2200 --def 2200

			-- render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
			if type(UserSettings.HigherRenderDist) == "number" then
				hr.DistanceModifier = UserSettings.HigherRenderDist
				hr.LODDistanceModifier = UserSettings.HigherRenderDist
			else
				hr.DistanceModifier = 600
				hr.LODDistanceModifier = 600
			end
		end

		if UserSettings.HigherShadowDist then
			if type(UserSettings.HigherShadowDist) == "number" then
				hr.ShadowRangeOverride = UserSettings.HigherShadowDist
			else
				-- shadow cutoff dist
				hr.ShadowRangeOverride = 1000000 --def 0
			end
			-- no shadow fade out when zooming
			hr.ShadowFadeOutRangePercent = 0 --def 30
		end

		-- default to showing interface in ss
		if UserSettings.ShowInterfaceInScreenshots then
			hr.InterfaceInScreenshot = 1
		end

		-- not sure why this would be false on a dome
		local domes = UICity.labels.Dome or ""
		for i = 1, #domes do
			local dome = domes[i]
			if dome.achievement == "FirstDome" and type(dome.connected_domes) ~= "table" then
				dome.connected_domes = {}
			end
		end

		-- something messed up if storage is negative (usually setting an amount then lowering it)
		local storages = UICity.labels.Storages or ""
		procall(function()
			for i = 1, #storages do
				local storage = storages[i]
				if storage:GetStoredAmount() < 0 then
					-- we have to empty it first (just filling doesn't fix the issue)
					storage:CheatEmpty()
					storage:CheatFill()
				end
			end
		end)

		-- so we can change the max_amount for concrete
		local terr_props = g_Classes.TerrainDepositConcrete.properties or ""
		for i = 1, #terr_props do
			local prop = terr_props[i]
			if prop.id == "max_amount" then
				prop.read_only = nil
			end
		end

		-- show all traits
		if UserSettings.SanatoriumSchoolShowAll then
			g_Classes.Sanatorium.max_traits = #ChoGGi.Tables.NegativeTraits
			g_Classes.School.max_traits = #ChoGGi.Tables.PositiveTraits
		end

		-- new version, not that i really need this anymore...
		if ChoGGi._VERSION ~= UserSettings._VERSION then
			-- update saved version
			UserSettings._VERSION = ChoGGi._VERSION
			ChoGGi.Temp.WriteSettings = true
		end

		CreateRealTimeThread(function()
			-- clean up my old notifications (doesn't actually matter if there's a few left, but it can spam log)
			local shown = g_ShownOnScreenNotifications or empty_table
			for key in pairs(shown) do
				if type(key) == "number" or tostring(key):find("ChoGGi_") then
					shown[key] = nil
				end
			end

			-- remove any dialogs we opened
			if UserSettings.CloseDialogsECM then
				ChoGGi.ComFuncs.CloseDialogsECM()
			end

		end)

		-- print startup msgs to console log
		if not testing then
			local msgs = ChoGGi.Temp.StartupMsgs
			for i = 1, #msgs do
				print(msgs[i])
			end
			table.iclear(ChoGGi.Temp.StartupMsgs)
		end

		-- everyone loves a new titlebar, unless they don't
		if UserSettings.ChangeWindowTitle then
			terminal.SetOSWindowTitle(Translate(1079--[[Surviving Mars--]]) .. ": " .. Strings[302535920000887--[[ECM--]]] .. " v" .. ChoGGi._VERSION)
		end

		-- first time run info
		if UserSettings.FirstRun ~= false then
			local function CallBackFunc(answer)
				if answer then
					DestroyConsoleLog()
				else
					UserSettings.ConsoleToggleHistory = true
					ShowConsoleLog(true)
					ChoGGi.SettingFuncs.WriteSettings()
				end
			end
			ChoGGi.ComFuncs.QuestionBox(
				Strings[302535920000001--[["F2 to toggle Cheats Menu (Ctrl-F2 for Cheats Pane), and F9 to clear console log text.
If this isn't a new install, then see Menu>Help>Changelog and search for ""To import your old settings""."--]]]
					.. "\n\n" .. Strings[302535920001309--[["Stop showing console log: Press Tilde or Enter and click the ""%s"" button then uncheck ""%s""."--]]]:format(Strings[302535920001308--[[Settings--]]],Strings[302535920001112--[[Console Log--]]]),
				CallBackFunc,
				Strings[302535920000000--[[Expanded Cheat Menu--]]] .. " " .. Strings[302535920000201--[[Active--]]],
				Strings[302535920001465--[[Stop talking and start cheating!--]]],
				Strings[302535920001466--[["I know what I'm doing, show me the console log."--]]],
				ChoGGi.mod_path .. "Preview.png"
			)
			-- second place is isn't last place
			UserSettings.FirstRun = false
			ChoGGi.Temp.WriteSettings = true
		end

		-- set zoom/border scrolling
		SetMouseDeltaMode(false)
		cameraRTS.Activate(1)
		engineShowMouseCursor()
		ChoGGi.ComFuncs.SetCameraSettings()



		------------------------------- always fired last



		-- make sure to save anything we changed above
		if ChoGGi.Temp.WriteSettings then
			ChoGGi.SettingFuncs.WriteSettings()
			ChoGGi.Temp.WriteSettings = nil
		end

		if UserSettings.FlushLog then
			FlushLogFile()
		end

		printC("<color 200 200 200>ECM</color>: <color 128 255 128>Testing Enabled</color>")

		-- how long startup takes
		if testing or UserSettings.ShowStartupTicks then
			print("<color 200 200 200>",Strings[302535920000887--[[ECM--]]],"</color>:",Strings[302535920000247--[[Startup ticks--]]],":",GetPreciseTicks() - ChoGGi.Temp.StartupTicks)
		end

		if not testing then
			-- getting tired of people asking how to disable console log
			print("<color 200 200 200>",Strings[302535920000887--[[ECM--]]],"</color>:",Strings[302535920001309--[["Stop showing these msgs: Press Tilde or Enter and click the ""%s"" button then uncheck ""%s""."--]]]:format(Strings[302535920001308--[[Settings--]]],Strings[302535920001112--[[Console Log--]]]))
		end

		-- used to check when game has started and it's safe to print() etc
		ChoGGi.Temp.GameLoaded = true

	end --OnMsg
end -- do

-- if i need to do something on a new game later then CityStart
--~ function OnMsg.RocketLaunchFromEarth()
--~ end