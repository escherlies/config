local meh = { "ctrl", "alt", "shift" }
local hyper = { "cmd", "shift", "alt", "ctrl" }

hs.alert.show("Config loaded")


hs.hotkey.bind(hyper, "l", function()
  hs.reload()
end)



-- Spotify volume controls
-- Useful for when you're listening to music and you're in a call
-- q(uiet)| w   | f(full) | p
-- 30%    | 60% | 100%    | play/pause
hs.hotkey.bind(hyper, "q",
  function()
    local currentVolume = hs.spotify.getVolume()
    -- Note that Spotify set's the volume to n-1 when you set it to n...
    local newVolume = currentVolume == 29 and 100 or 30
    hs.spotify.setVolume(newVolume)
  end
)

hs.hotkey.bind(hyper, "w",
  function()
    local currentVolume = hs.spotify.getVolume()
    -- Note that Spotify set's the volume to n-1 when you set it to n...
    local newVolume = currentVolume == 60 and 100 or 60
    hs.spotify.setVolume(newVolume)
  end
)

hs.hotkey.bind(hyper, "f",
  function()
    hs.spotify.setVolume(100)
  end
)

-- Tooggle Spotify play/pause
-- Useful for when you've started a youtube video and you want to pause the music (because )
hs.hotkey.bind(hyper, "p",
  function()
    hs.spotify.playpause()
  end
)

-- Toggle dark mode
-- Useful because the "Auto" mode has bad timing
hs.hotkey.bind(hyper, "d",
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
  { "t", "iTerm" },
  { "s", "Spotify" },
  { "c", "Visual Studio Code" },
  { "r", "Firefox" },
}

-- Function to toggle the application
local function toggleApplication(appName)
  local app = hs.application.get(appName)

  if app and app:isFrontmost() then
    app:hide()
  else
    hs.application.launchOrFocus(appName)
  end
end


hs.fnutils.each(appShortcuts, function(config)
  local shortcut = config[1]
  local app = config[2]
  hs.hotkey.bind(hyper, shortcut, function() toggleApplication(app) end)
end)


-- Quick search for an fontawesome icon
hs.hotkey.bind(hyper, "i", function()
  local button, textInput = hs.dialog.textPrompt("Icon Search", "Search for an icon:")

  if textInput == nil or textInput == "" then
    return
  end

  -- Open the Font Awesome website
  -- Example: https://fontawesome.com/search?q=foo&o=r&s=light&f=classic
  local url = "https://fontawesome.com/search?q=" .. textInput .. "&o=r&s=light&f=classic"
  hs.urlevent.openURL(url)
end)
