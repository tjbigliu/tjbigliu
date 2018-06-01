--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.GameMenu_LoadingScreenPreClose()

  ChoGGi.ComFuncs.AddAction(
    "Game/Change Terrain Type",
    ChoGGi.MenuFuncs.ChangeTerrainType,
    nil,
    "Green or Icy mars? Coming right up!",
    "prefabs.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/Change Light Model",
    ChoGGi.MenuFuncs.ChangeLightmodel,
    nil,
    "Changes the lighting mode (temporary or permanent).",
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/Change Light Model Custom",
    ChoGGi.MenuFuncs.ChangeLightmodelCustom,
    nil,
    "Make a custom lightmodel and save it to settings. You still need to use \"Change Light Model\" for permanent.",
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/Set UI Transparency",
    ChoGGi.MenuFuncs.SetTransparencyUI,
    "Ctrl-F3",
    "Change the transparency of UI items (info panel, menu, pins).",
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/Set UI Transparency Mouseover",
    ChoGGi.MenuFuncs.TransparencyUI_Toggle,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.TransparencyToggle)
      return des .. " Toggle removing transparency on mouseover."
    end,
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/Lights Radius",
    ChoGGi.MenuFuncs.SetLightsRadius,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.LightsRadius)
      return des .. "\nSets light radius (Menu>Options>Video>Lights), menu options max out at 100.\nLets you see lights from further away/more bleedout?"
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/Terrain Detail",
    ChoGGi.MenuFuncs.SetTerrainDetail,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.TerrainDetail)
      return des .. "\nSets hr.TR_MaxChunks (Menu>Options>Video>Terrain), menu options max out at 200.\nMakes the background terrain more detailed (make sure to also stick Terrain on Ultra in the options menu)."
    end,
    "selslope.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/Video Memory",
    ChoGGi.MenuFuncs.SetVideoMemory,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.VideoMemory)
      return des .. "\nSets hr.DTM_VideoMemory (Menu>Options>Video>Textures), menu options max out at 2048."
    end,
    "CountPointLights.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/Shadow Map",
    ChoGGi.MenuFuncs.SetShadowmapSize,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.ShadowmapSize)
      return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096."
    end,
    "DisableEyeSpec.tga"
  )

  --------------------
  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/Disable Texture Compression",
    ChoGGi.MenuFuncs.DisableTextureCompression_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableTextureCompression and "(Enabled)" or "(Disabled)"
      return des .. " Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram)."
    end,
    "ExportImageSequence.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/Higher Render Distance",
    ChoGGi.MenuFuncs.HigherRenderDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherRenderDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders model from further away.\nNot noticeable unless using higher zoom."
    end,
    "CameraEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/Higher Shadow Distance",
    ChoGGi.MenuFuncs.HigherShadowDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherShadowDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders shadows from further away.\nNot noticeable unless using higher zoom."
    end,
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/Border Scrolling",
    ChoGGi.MenuFuncs.SetBorderScrolling,
    nil,
    function()
      local des = ChoGGi.UserSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
      return des .. " Set size of activation for mouse border scrolling."
    end,
    "CameraToggle.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/Zoom Distance",
    ChoGGi.MenuFuncs.CameraZoom_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CameraZoomToggle and "(Enabled)" or "(Disabled)"
      return des .. " Further zoom distance."
    end,
    "MoveUpCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/Toggle Free Camera",
    ChoGGi.MenuFuncs.CameraFree_Toggle,
    "Shift-C",
    "I believe I can fly.",
    "NewCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/Toggle Follow Camera",
    ChoGGi.MenuFuncs.CameraFollow_Toggle,
    "Ctrl-Shift-F",
    "Select (or mouse over) an object to follow.",
    "Shot.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/Toggle Cursor",
    ChoGGi.MenuFuncs.CursorVisible_Toggle,
    "Ctrl-Alt-F",
    "Toggle between moving camera and selecting objects.",
    "select_objects.tga"
  )

end