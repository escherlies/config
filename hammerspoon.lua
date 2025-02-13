local meh = { "ctrl", "alt", "shift" }
local hyper = { "cmd", "shift", "alt", "ctrl" }

hs.alert.show("Config loaded")

hs.window.animationDuration = 1000

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

local cache = ""

hs.hotkey.bind(hyper, "x", function()
  local button, textInput = hs.dialog.textPrompt("Cache", cache)

  if textInput == nil or textInput == "" then
    return
  end

  cache = textInput


  -- Open the Font Awesome website
  -- Example: https://fontawesome.com/search?q=foo&o=r&s=light&f=classic
  -- local url = "https://fontawesome.com/search?q=" .. textInput .. "&o=r&s=light&f=classic"
  -- hs.urlevent.openURL(url)
end)


function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

-- Define a hotkey, e.g., Ctrl+Space (customize as you wish)
-- Don't use blocking sleep. Instead, use hs.timer.doAfter or doWhile
-- Or gather all windows before showing the chooser

function TableConcat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

hs.hotkey.bind(hyper, "space", function()
  local chooser = hs.chooser.new(function(chosen)
    if chosen then
      if chosen.isWindow then
        -- Focusing an existing window
        local chosenWindow = hs.window.get(chosen.uuid)
        if chosenWindow then
          chosenWindow:focus()
        end
      else
        -- Activating an application that has no open windows
        local app = hs.application.get(chosen.uuid)
        if app then
          -- app:activate()
          hs.application.launchOrFocus(app:name())
        end
      end
    end
  end)

  chooser:searchSubText(true)
  chooser:choices({}) -- Start empty before we populate
  chooser:show()

  local choices = {}
  local appsWithWindows = {}

  -- 1. Collect all windows (only from regular GUI apps)
  local allWindows = hs.window.allWindows()
  for _, w in ipairs(allWindows) do
    local app = w:application()
    if app and app:kind() == 1 then -- Only “regular” GUI apps
      table.insert(choices, {
        text     = w:title() or "[Untitled]",
        subText  = app:name(),
        uuid     = w:id(),
        isWindow = true
      })
      appsWithWindows[app:bundleID()] = true
    end
  end

  -- 2. Add running apps that have no windows (again, only if they’re regular GUI apps)
  for _, app in ipairs(hs.application.runningApplications()) do
    if app:kind() == 1 then
      local bundleID = app:bundleID()
      if bundleID and not appsWithWindows[bundleID] then
        table.insert(choices, {
          text     = app:name() or "[Unnamed App]",
          subText  = "No windows open",
          uuid     = bundleID,
          isWindow = false
        })
      end
    end
  end

  chooser:choices(choices)
end)
