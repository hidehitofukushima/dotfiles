-- -----------------------------------------------------------------------------
-- 基本設定
-- -----------------------------------------------------------------------------
vim.opt.ignorecase = true                       -- 大文字と小文字を区別しない
vim.opt.smartcase = true                        -- ただし、検索文字に大文字が含まれている場合は区別する (スマートケース)
vim.o.number = true                             -- 行番 を表示
vim.o.shiftwidth = 2                            -- インデントの幅をスペース4つ分に設定
vim.o.relativenumber = true                     -- 現在行を0として相対的な行番号を表示
vim.o.signcolumn = "yes"                        -- 常にサインコラムを表示（lspの警告やgitの差分表示用）
vim.o.wrap = false                              -- 長い行を折り返さない
vim.o.tabstop = 2                               -- タブの幅をスペース4つ分に設定
vim.o.swapfile = false                          -- スワップファイルを作成しない
vim.o.winborder = "rounded"                     -- ウィンドウの境界線を角丸にする
vim.g.mapleader = " "                           -- リーダーキーをスペースキーに設定
vim.o.clipboard = "unnamedplus"                 -- システムクリップボードを使用
vim.g.slime_no_mappings = 1                      -- デフォルトのキーマップを無効化
vim.g.slime_dont_ask_default = 1                 -- デフォルトのターゲットを尋ねない
vim.g.slime_cell_delimiter = "##"
vim.g.slime_target = "tmux"                     -- slimeのターゲットをtmuxに設定
vim.g.slime_default_config = {
	socket_name = "default", -- tmuxのソケット名をフルパスで指定
	target_pane = ":1",                          -- ターゲットペインを指定 
	-- (ターゲットペインは、ファイル名のみでなく、ファイル名とパスも含めることができます)
	send_timeout = 0,                             -- 送信タイムアウトを無効化
}
-- plugin
-- -----------------------------------------------------------------------------
-- プラグイン管理 (built-in package manager)
-- -----------------------------------------------------------------------------
vim.pack.add({
	{ src = "https://github.com/nvzone/volt" }, -- Volt
	{ src = "https://github.com/nvzone/typr" }, -- typr
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/echasnovski/mini.starter" },
	{ src = "https://github.com/echasnovski/mini.sessions" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/jpalardy/vim-slime" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/karb94/neoscroll.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
})

vim.cmd("set completeopt+=noselect")
-- -----------------------------------------------------------------------------
-- 各機能の設定とキーマップ (configurations & keymaps)
-- -----------------------------------------------------------------------------
-- require "mason".setup()                                                    -- Masonのセットアップ
require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<C-k>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
  ignore_filetypes = { cpp = true }, -- or { "cpp", }
  color = {
    suggestion_color = "#ffffff",
    cterm = 244,
  },
  log_level = "info", -- set to "off" to disable logging completely
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false, -- disables built in keymaps for more manual control
  condition = function()
    return false
  end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
})
require('neoscroll').setup({
	mappings = { -- Keys to be mapped to their corresponding default scrolling animation
		'<C-u>', '<C-d>',
		'<C-b>', '<C-f>',
		'<C-y>', '<C-e>',
		'zt', 'zz', 'zb',
	},
	hide_cursor = true,         -- Hide cursor while scrolling
	stop_eof = true,            -- Stop at <EOF> when scrolling downwards
	respect_scrolloff = false,  -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	duration_multiplier = 1.0,  -- Global duration multiplier
	easing = 'linear',          -- Default easing function
	pre_hook = nil,             -- Function to run before the scrolling animation starts
	post_hook = nil,            -- Function to run after the scrolling animation ends
	performance_mode = false,   -- Disable "Performance Mode" on all buffers.
	ignored_events = {          -- Events ignored while scrolling
		'WinScrolled', 'CursorMoved'
	},
})
require "nvim-treesitter.configs".setup({
	ensure_installed = { "lua", "bash", "markdown", "markdown_inline", "r" }, -- 必要な言語を指定
	highlight = {
		enable = true,                                                         -- シンタックスハイライトを有効化
	},
	indent = {
		enable = true, -- インデントを有効化
	},
})
require("bufferline").setup()
require("mini.pick").setup()
require("mini.sessions").setup()
local starter = require("mini.starter")
starter.setup({
	-- スターターページの設定
	items = {
		starter.sections.sessions(15, true),
	},
})
-- require("oil").setup()
-- oil.nvim の設定
require('oil').setup({
	default_file_explorer = true,        -- デフォルトのファイルエクスプローラーとして使用
	delete_to_trash = true,              -- ファイルを削除する際にゴミ箱に移動
	skip_confirm_for_simple_edits = true, -- 簡単な編集では確認をスキップ
	view_options = {
		show_hidden = true,                -- 隠しファイルを表示
		show_parent_dir = true,            -- 親ディレクトリを表示
		natural_order = true,              -- 自然順序でソート
	},
	keymaps = {
		['yf'] = {
			desc = 'Copy file to system clipboard',
			callback = function()
				require("oil.actions").copy_to_system_clipboard.callback()
			end,
		},
		['yp'] = {
			desc = 'Copy filepath to system clipboard',
			callback = function()
				-- require('oil.actions').copy_entry_path.callback()
				require('oil.actions').yank_entry.callback()
			end,
		},
		['yo'] = {
			desc = 'Copy dirpath to system clipboard',
			callback = function()
				-- require('oil.actions').copy_entry_path.callback()
				require('oil.actions').yank_entry.callback()
				local a = vim.fn.getreg(vim.v.register)
				print("a" .. a)
				-- dirpath a 
				b = vim.fn.fnamemodify(a, ":h")
				-- set b to clipboard
				vim.fn.setreg("+", b)
				vim.notify("dirpath copied to clipboard")
			end,
		},
	      



		-- ▼▼▼ 以下をkeymapsテーブル内に追加 ▼▼▼
				['gj'] = {
			desc = "Open finder",
			callback = function()
				-- カーソル下のファイル情報を取得
				require('oil.actions').yank_entry.callback()
				local a = vim.fn.getreg(vim.v.register)
				vim.cmd("silent !open -R " .. vim.fn.fnameescape(a))
			end,
		},
				['gh'] = {
			desc = "Open with shell's `open` command or default external app",
			callback = function()
				-- カーソル下のファイル情報を取得
				require('oil.actions').yank_entry.callback()
				local a = vim.fn.getreg(vim.v.register)
				vim.cmd("silent !open " .. vim.fn.fnameescape(a))
			end,
		},

	},
	-- その他のoil.nvimの設定があればここに追加
})
-- キーマップ
--
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<leader>l", "<Plug>SlimeLineSend", opts)
keymap("x", "<leader>l", "<Plug>SlimeRegionSend", opts) -- 選択範囲の送信
keymap("n", "<leader>p", "vip<Plug>SlimeRegionSend", opts) -- 段落の送信
keymap("n", "<leader>c", "<Plug>SlimeSendCell", opts) -- セルの送信
keymap("n", "<leader>w", ":bd<CR>", opts)
keymap("n", "<leader>ww", ":bd!<CR>", opts)
keymap("n", "<leader>s", ":write<CR>", opts)
keymap("n", "<leader>ss", ":update<CR> :source %<CR>", opts)
keymap("n", "<leader>q", ":q!<CR>", opts)
keymap("n", "<C-l>", ":bnext<CR>", opts)          -- Normalモード: 次のバッファへ
keymap("i", "<C-l>", "<C-o>:bnext<CR>", opts)     -- Insertモード: 次のバッファへ
keymap("n", "<C-h>", ":bprevious<CR>", opts)      -- Normalモード: 前のバッファへ
keymap("i", "<C-h>", "<C-o>:bprevious<CR>", opts) -- Insertモード: 前のバッファへ
keymap("n", "<leader>t", ":enew<CR>", opts)
keymap("n", "<leader>f", ":Pick files<CR>", opts)
keymap("n", "<leader>h", ":Pick help<CR>", opts)
keymap("n", "<leader>e", ":Oil<CR>", opts)
keymap("i", "jk", "<Esc>", opts)
keymap("n", "<leader>lf", vim.lsp.buf.format, opts)
keymap("n", "<leader>m", ":e /Users/fukushimahideto/dotfiles/.memo<CR>", opts)
-- --------------------/<---------------------------------------------------------
-- カラースキーム (Colorscheme)
-- -- -----------------------------------------------------------------------------
-- vim.cmd("colorscheme minischeme")
vim.cmd("hi StatusLine guibg=NONE")
local function is_blank(arg)
	return arg == nil or arg == ''
end
local function get_sessions(lead)
	-- ref: https://qiita.com/delphinus/items/2c993527df40c9ebaea7
	return vim
			.iter(vim.fs.dir(MiniSessions.config.directory))
			:map(function(v)
				local name = vim.fn.fnamemodify(v, ':t:r')
				return vim.startswith(name, lead) and name or nil
			end)
			:totable()
end
vim.api.nvim_create_user_command('SessionWrite', function(arg)
	local session_name = is_blank(arg.args) and vim.v.this_session or arg.args
	if is_blank(session_name) then
		vim.notify('No session name specified', vim.log.levels.WARN)
		return
	end
	vim.cmd('%argdelete') -- init.lua などに追記

	-- ホバーウィンドウを「フォーカス可能」にする
	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
		vim.lsp.handlers.hover, {
			-- この focusable = true が重要です
			focusable = true,

			-- お好みで見た目を変更（角丸の境界線）
			border = 'rounded'
		}
	)

	-- シグネチャヘルプ（関数の引数情報）のウィンドウも同様に設定
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
		vim.lsp.handlers.signature_help, {
			focusable = true,
			border = 'rounded'
		}
	)
	MiniSessions.write(session_name)
end, { desc = 'Write session', nargs = '?', complete = get_sessions })
vim.api.nvim_create_user_command('SessionDelete', function(arg)
	MiniSessions.select('delete', { force = arg.bang })
end, { desc = 'Delete session', bang = true })
vim.api.nvim_create_user_command('SessionLoad', function()
	MiniSessions.select('read', { verbose = true })
end, { desc = 'Load session' })

vim.api.nvim_create_user_command('SessionEscape', function()
	vim.v.this_session = ''
end, { desc = 'Escape session' })

vim.api.nvim_create_user_command('SessionReveal', function()
	if is_blank(vim.v.this_session) then
		vim.print('No session')
		return
	end
	vim.print(vim.fn.fnamemodify(vim.v.this_session, ':t:r'))
end, { desc = 'Reveal session' })

