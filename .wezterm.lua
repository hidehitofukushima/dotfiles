--------------------------------------------------------------------------------
-- Wezterm configuration
--------------------------------------------------------------------------------
local wezterm = require 'wezterm'
local config = {}

config.initial_cols = 200
config.initial_rows = 40
config.scrollback_lines = 2500
config.enable_scroll_bar = true
config.font_size = 12
config.font = wezterm.font 'Menlo'
-- config.font = wezterm.font('Mono', {weight = 'Bold', italic = true})
config.line_height = 1.2
-- default cwd
config.default_cwd = "~/Desktop"
-- prefixキーの設定（Ctrl + Space）
config.leader = {
    key = "q",
    mods = "CTRL",
    timeout_milliseconds = 2000,
}
config.keys = {
    -- quick select (tmux-fingers)
    {
        mods = "LEADER",
        key = "F",
        action = wezterm.action.QuickSelect,
    },
}
table.insert(config.keys, {
    -- ¥でバックスラッシュ
    key = "¥",
    action = wezterm.action.SendKey({ key = "\\" }),
})
table.insert(config.keys, {
    -- ALT + ¥で¥
    key = "¥",
    mods = "ALT",
    action = wezterm.action.SendKey({ key = "¥" }),
})
--------------------------------------------------------------------------------
-- my custom color scheme
--------------------------------------------------------------------------------
config.color_scheme = 'Dracula+'
config.color_scheme = 'purplepeter'
config.colors = {
  -- the first number is the hue measured in degrees with a range
  -- of 0-360.
  -- The second number is the saturation measured in percentage with
  -- a range of 0-100.
  -- The third number is the lightness measured in percentage with
  -- a range of 0-100.
  foreground = '#4B3D66',
	background = '#FFFFFF',
}
return config
