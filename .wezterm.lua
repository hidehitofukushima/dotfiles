--------------------------------------------------------------------------------
-- Wezterm configuration
--------------------------------------------------------------------------------
local wezterm = require 'wezterm'
local config = {}

config.initial_cols = 120
config.initial_rows = 28
config.scrollback_lines = 2500
config.enable_scroll_bar = true
config.font_size = 14
config.font = wezterm.font 'Menlo'
-- config.font = wezterm.font('Mono', {weight = 'Bold', italic = true})
config.line_height = 1.2

--------------------------------------------------------------------------------
-- my custom color scheme
--------------------------------------------------------------------------------
config.colors = {
  -- The default text color
  foreground = '#705697',
  -- The default background color
  background = '#FFFFFF',

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#705697',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = '#705697',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = '#705697',

  -- the foreground color of selected text
  selection_fg = '#705697',
  -- the background color of selected text
  selection_bg = '#705697',


  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#705697',

  -- The color of the split lines between panes
  split = '#705697',

  ansi = {
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    -- 'maroon',
    -- '#705697',
    -- 'olive',
    -- 'black',
    -- 'purple',
    -- '#AA3731',
    -- '#705697',
  },
  brights = {
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
    '#705697',
  },
	
  -- Arbitrary colors of the palette in the range from 16 to 255
  indexed = { [136] = '#af8700' },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = 'orange',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = '#000000' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },

  input_selector_label_bg = { AnsiColor = 'Black' }, -- (*Since: Nightly Builds Only*)
  input_selector_label_fg = { Color = '#ffffff' }, -- (*Since: Nightly Builds Only*)

  launcher_label_bg = { AnsiColor = 'Black' }, -- (*Since: Nightly Builds Only*)
  launcher_label_fg = { Color = '#ffffff' }, -- (*Since: Nightly Builds Only*)
}
return config
