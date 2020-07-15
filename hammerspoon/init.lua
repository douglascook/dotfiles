-- Move mouse focus between displays so that swapping desktops with ctrl-left/right works
hs.hotkey.bind({"ctrl", "cmd"}, "Left", function()
  local currentScreen = hs.mouse.getCurrentScreen()
  local nextScreen = currentScreen:toWest()
  if nextScreen then
    local frame = nextScreen:frame()
    -- move mouse to centre of the next screen
    hs.mouse.setRelativePosition({x = frame.w / 2, y = frame.h / 2}, nextScreen)
  end
end)

hs.hotkey.bind({"ctrl", "cmd"}, "Right", function()
  local currentScreen = hs.mouse.getCurrentScreen()
  local nextScreen = currentScreen:toEast()
  if nextScreen then
    local frame = nextScreen:frame()
    -- move mouse to centre of the next screen
    hs.mouse.setRelativePosition({x = frame.w / 2, y = frame.h / 2}, nextScreen)
  end
end)


-- SPOONS!
--
-- reload the config automatically on change
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Config loaded")
