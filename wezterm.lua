--------------------------------------------------------------------------------
-- Wezterm configuration
--------------------------------------------------------------------------------
local wezterm = require 'wezterm'
local config = {}

config.initial_cols = 200
config.initial_rows = 40
config.scrollback_lines = 2500
config.enable_scroll_bar = true
config.font_size = 14
config.font = wezterm.font 'Menlo'
-- config.font = wezterm.font('Mono', {weight = 'Bold', italic = true})
-- Nerd Fontをプライマリフォントとして設定
-- config.font = wezterm.font_with_fallback({
--   -- ここにダウンロードしたNerd Fontの名前を指定
--   'FiraCode Nerd Font Mono',
--   -- fallback フォント（日本語用など）
--   'Noto Sans Mono CJK JP',
-- })
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
-- config.background = {
-- 	{
-- 		source = { File = '/Users/fukushimahideto/DOTFILES/snoopy.jpeg' },
-- 		opacity = 0,
-- 		width = "10%",
-- 		height = "10%",
-- 		repeat_x = 'NoRepeat',
-- 		repeat_y = 'NoRepeat',
-- 	},
-- }
-- config.window_background_opacity = 0.93
-- config.text_background_opacity = 0.9

config.color_scheme = 'Vs Code Light+ (Gogh)'
config.color_scheme = 'AtomOneLight'
config.colors = {
  -- the first number is the hue measured in degrees with a range
  -- of 0-360.
  -- The second number is the saturation measured in percentage with
  -- a range of 0-100.
  -- The third number is the lightness measured in percentage with
  -- a range of 0-100.
  foreground = '#6C5793',
	background = '#FFFFFF',
}
config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 14.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = '#6C5793',
  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = '#ffffff',
}


return config
