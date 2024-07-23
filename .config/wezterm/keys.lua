---@type wezterm
local wezterm = require("wezterm")
local io = require 'io'
local os = require 'os'
local utils = require 'utils'
local act = wezterm.action

local shortcuts = {}

---@param key string
---@param mods string|string[]
---@param action wezterm.Action
---@return nil
local map = function(key, mods, action)
  if type(mods) == "string" then
    table.insert(shortcuts, { key = key, mods = mods, action = action })
  elseif type(mods) == "table" then
    for _, mod in pairs(mods) do
      table.insert(shortcuts, { key = key, mods = mod, action = action })
    end
  end
end

-- use 'CTRL e' to open the current scrollback in $EDITOR
wezterm.on('trigger-editor-with-scrollback', function(window, pane)
  -- Retrieve the text from the pane
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
  -- Create a temporary file to pass to vim
  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(text)
  f:flush()
  f:close()

  local args = nil

  -- Open a new window running vim and tell it to open the file
  if utils.is_windows() then
    args = { "fish", "-c", string.format('$EDITOR (wslpath "%s")', name) }
  else
    args = { "$EDITOR", name }
  end

  window:perform_action(
    act.SpawnCommandInNewWindow {
      args = args,
    },
    pane
  )
  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  --
  -- Note: We don't strictly need to remove this file, but it is nice
  -- to avoid cluttering up the temporary directory.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)
map("e", "CTRL", act.EmitEvent("trigger-editor-with-scrollback"))

local toggleTabBar = wezterm.action_callback(function(window)
  window:set_config_overrides({
    enable_tab_bar = not window:effective_config().enable_tab_bar,
  })
end)

local openUrl = act.QuickSelectArgs({
  label = "open url",
  patterns = {
    "https?://\\S+",
  },
  action = wezterm.action_callback(function(window, pane)
    local url = window:get_selection_text_for_pane(pane)
    wezterm.open_with(url)
  end),
})


-- use 'Backslash' to split horizontally
map("\\", "LEADER", act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
-- and 'Minus' to split vertically
map("-", "LEADER", act.SplitVertical({ domain = "CurrentPaneDomain" }))
-- map 1-9 to switch to tab 1-9, 0 for the last tab
for i = 1, 9 do
  map(tostring(i), { "LEADER", "SUPER" }, act.ActivateTab(i - 1))
end
map("0", { "LEADER", "SUPER" }, act.ActivateTab(-1))
-- 'hjkl' to move between panes
map("h", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Left"))
map("j", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Down"))
map("k", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Up"))
map("l", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Right"))
-- resize
map("h", "LEADER|SHIFT", act.AdjustPaneSize({ "Left", 5 }))
map("j", "LEADER|SHIFT", act.AdjustPaneSize({ "Down", 5 }))
map("k", "LEADER|SHIFT", act.AdjustPaneSize({ "Up", 5 }))
map("l", "LEADER|SHIFT", act.AdjustPaneSize({ "Right", 5 }))
-- spawn & close
map("c", "LEADER", act.SpawnTab("CurrentPaneDomain"))
map("x", "LEADER", act.CloseCurrentPane({ confirm = true }))
map("t", { "SHIFT|CTRL", "SUPER" }, act.SpawnTab("CurrentPaneDomain"))
map("w", { "SHIFT|CTRL", "SUPER" }, act.CloseCurrentTab({ confirm = true }))
map("n", { "SHIFT|CTRL", "SUPER" }, act.SpawnWindow)
-- zoom states
map("z", { "LEADER", "SUPER" }, act.TogglePaneZoomState)
map("Z", { "LEADER", "SUPER" }, toggleTabBar)
-- copy & paste
map("v", "LEADER", act.ActivateCopyMode)
map("c", { "SHIFT|CTRL", "SUPER" }, act.CopyTo("Clipboard"))
map("v", { "SHIFT|CTRL", "SUPER" }, act.PasteFrom("Clipboard"))
map("f", { "SHIFT|CTRL", "SUPER" }, act.Search({ CaseInSensitiveString = "" }))
-- rotation
map("e", { "LEADER", "SUPER" }, act.RotatePanes("Clockwise"))
-- pickers
map(" ", "LEADER", act.QuickSelect)
map("o", { "LEADER", "SUPER" }, openUrl)
map("p", { "LEADER", "SUPER" }, act.PaneSelect({ alphabet = "asdfghjkl;" }))
map("R", { "LEADER", "SUPER" }, act.ReloadConfiguration)
map("u", "SHIFT|CTRL", act.CharSelect)
map("p", { "SHIFT|CTRL", "SHIFT|SUPER" }, act.ActivateCommandPalette)
-- view
map("Enter", "ALT", act.ToggleFullScreen)
map("-", { "CTRL", "SUPER" }, act.DecreaseFontSize)
map("=", { "CTRL", "SUPER" }, act.IncreaseFontSize)
map("0", { "CTRL", "SUPER" }, act.ResetFontSize)
-- switch fonts
map("f", "LEADER", act.EmitEvent("switch-font"))
-- debug
map("l", "SHIFT|CTRL", act.ShowDebugOverlay)

map(
  "r",
  { "LEADER", "SUPER" },
  act.ActivateKeyTable({
    name = "resize_mode",
    one_shot = false,
  })
)

local new_copy_mode = wezterm.gui.default_key_tables().copy_mode
local additional_bindings = {
  -- Enter search mode to edit the pattern.
  -- When the search pattern is an empty string the existing pattern is preserved
    {key="/", mods="NONE", action=wezterm.action{Search={CaseSensitiveString=""}}},
    -- navigate any search mode results
    {key="n", mods="NONE", action=wezterm.action{CopyMode="NextMatch"}},
    {key="N", mods="SHIFT", action=wezterm.action{CopyMode="PriorMatch"}},
}

for _, binding in ipairs(additional_bindings) do
  table.insert(new_copy_mode, binding)
end

local key_tables = {
  resize_mode = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 2 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 2 }) },
    { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 2 }) },
  },
  copy_mode = new_copy_mode,
  search_mode = {
    {key="Escape", mods="NONE", action=wezterm.action{CopyMode="Close"}},
    -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
    -- to navigate search results without conflicting with typing into the search area.
    {key="Enter", mods="NONE", action="ActivateCopyMode"},
  },
}

-- add a common escape sequence to all key tables
for k, _ in pairs(key_tables) do
  -- These might not be needed, experimenting with not having them:
  -- table.insert(key_tables[k], { key = "Escape", action = "PopKeyTable" })
  -- table.insert(key_tables[k], { key = "Enter", action = "PopKeyTable" })
  table.insert(
    key_tables[k],
    { key = "c", mods = "CTRL", action = "PopKeyTable" }
  )
end

local M = {}
M.apply = function(c)
  c.leader = {
    key = "s",
    mods = "CTRL",
    timeout_milliseconds = math.maxinteger,
  }
  c.keys = shortcuts
  c.disable_default_key_bindings = true
  c.key_tables = key_tables
  c.mouse_bindings = {
    {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = "NONE",
      action = act.ScrollByLine(5),
    },
    {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = "NONE",
      action = act.ScrollByLine(-5),
    },
  }
end
return M
