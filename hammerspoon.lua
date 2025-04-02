local meh = { "ctrl", "alt", "shift" }
local hyper = { "cmd", "shift", "alt", "ctrl" }

hs.alert.show("Config loaded")


hs.hotkey.bind(hyper, "l", function()
  hs.reload()
end)




-- Toggle dark mode
-- Useful because the "Auto" mode has bad timing
hs.hotkey.bind(hyper, ";",
  function()
    hs.osascript.applescript([[
      tell application "System Events"
        tell appearance preferences
          set dark mode to not dark mode
        end tell
      end tell
    ]])
  end
)


hs.hotkey.showHotkeys(hyper, "h")

-- Application Shortcuts
local appShortcuts = {
  { "i", "iTerm" },
  { "e", "Visual Studio Code" },
  { "n", "Firefox" },
  { "o", "Firefox Developer Edition" },
}

-- Store the last active application
local lastApp = nil

-- Watch for application activations and store the last one
hs.application.watcher.new(function(appName, event, app)
  if event == hs.application.watcher.activated then
    -- Store the last application, but avoid replacing it with the same app consecutively
    if lastApp ~= app then
      lastApp = app
    end
  end
end):start()

local function toggleApplication(appName)
  local frontmostApp = hs.application.frontmostApplication()
  local app = hs.application.get(appName)

  if app and app:isFrontmost() then
    -- Switch back to the last used application instantly
    if lastApp and lastApp:isRunning() then
      lastApp:activate()
    end
  else
    -- Launch or focus the requested app and track the previous one
    lastApp = frontmostApp
    hs.application.launchOrFocus(appName)
  end
end


hs.fnutils.each(appShortcuts, function(config)
  local shortcut = config[1]
  local app = config[2]
  hs.hotkey.bind(hyper, shortcut, function() toggleApplication(app) end)
end)


-- Quick search for an fontawesome icon
hs.hotkey.bind(hyper, "u", function()
  local button, textInput = hs.dialog.textPrompt("Icon Search", "Search for an icon:")

  if textInput == nil or textInput == "" then
    return
  end

  -- Open the Font Awesome website
  -- Example: https://fontawesome.com/search?q=foo&o=r&s=light&f=classic
  local url = "https://fontawesome.com/search?q=" .. textInput .. "&o=r&s=light&f=classic"
  hs.urlevent.openURL(url)
end)
