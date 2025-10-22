-- =============================================================================
-- 基本設定 / Options & Globals（整理版）
-- =============================================================================
-- キーマップショートカット
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- -----------------------------------------------------------------------------
-- 基本オプション
-- -----------------------------------------------------------------------------
vim.opt.mouse = ""       -- マウス無効
vim.opt.swapfile = false -- スワップ無効
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- リーダーキー
vim.g.mapleader = " "

-- -----------------------------------------------------------------------------
-- 行折り返し設定（※重複/矛盾の除去: wrap は true を採用）
-- -----------------------------------------------------------------------------
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3)
vim.opt.linebreak = true
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- -----------------------------------------------------------------------------
-- クリップボード (OSC52)
-- -----------------------------------------------------------------------------
vim.schedule(function()
	vim.opt.clipboard:append('unnamedplus')
	vim.g.clipboard = {
		name = 'OSC 52',
		copy = {
			['+'] = require('vim.ui.clipboard.osc52').copy('+'),
			['*'] = require('vim.ui.clipboard.osc52').copy('*'),
		},
		paste = {
			['+'] = require('vim.ui.clipboard.osc52').paste('+'),
			['*'] = require('vim.ui.clipboard.osc52').paste('*'),
		},
	}
end)

-- =============================================================================
-- 起動高速化 + Diagnostics
-- =============================================================================
pcall(vim.loader.enable)

vim.diagnostic.config({
	virtual_text = { spacing = 1, prefix = "●" },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
vim.opt.updatetime = 200

-- =============================================================================
-- プラグイン管理（重複除去済み）
-- =============================================================================
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = "main" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = 'https://github.com/ibhagwan/fzf-lua' },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/jpalardy/vim-slime" },
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/Kaiser-Yang/blink-cmp-dictionary" },
	{ src = "https://github.com/folke/which-key.nvim" }, -- which-key
	{ src = "https://github.com/echasnovski/mini.surround" },
})

-- =============================================================================
-- mini.surround
-- =============================================================================
require("mini.surround").setup()
-- =============================================================================
-- which-key
-- =============================================================================
require("which-key").setup({})

-- =============================================================================
-- LSP / 補完（blink.cmp + LuaSnip）
-- =============================================================================
require("blink.cmp").setup({
	completion = { documentation = { auto_show = true, auto_show_delay_ms = 500 } },
	sources = {
		default = { "snippets", "lsp", "path", "buffer", },
	},
	snippets = { preset = "luasnip" }, -- 明示
	keymap = {
		preset = "super-tab",
		["<C-q>"] = { 'show', 'show_documentation', 'hide_documentation' },
		["<C-e>"] = { "hide" },
	},
	signature = { enabled = true },
	-- cmdline = { keymap = { preset = "super-tab" } },
})

-- LuaSnip 設定 + VSCode 形式スニペットの遅延ロード
require("luasnip").config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true, -- ★ autosnippet 有効
})
require("luasnip.loaders.from_vscode").lazy_load()

-- Mason 系
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"bash-language-server",
		"lua_ls",
		"basedpyright",
		"r_language_server",
	},
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			diagnostics = { globals = { 'vim', 'require' } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	}
})

-- =============================================================================
-- R用 %>% / <- スニペット（現行挙動維持: zzp / zzl）
-- =============================================================================
local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node

ls.add_snippets("r", {
	s({ trig = "zzp", dscr = "magrittr pipe", wordTrig = true, snippetType = "autosnippet" }, t("%>%")),
	s({ trig = "zzl", dscr = "left assignment", wordTrig = true, snippetType = "autosnippet" }, t("<-")),
}, { key = "r-ops-auto" })

ls.add_snippets("all", {
	s({ trig = "hdr", dscr = "header", wordTrig = true },
		{
			t({
				"###########################################",
				"# ",
				"###########################################",
			}),
			i(0),
		}
	)
}
, { key = "header" })
-- =============================================================================
-- supermaven
-- =============================================================================
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<C-k>",
		clear_suggestion = "<C-]>",
		accept_word = "<Tab>",
	},
	ignore_filetypes = { cpp = true },
	color = { suggestion_color = "#3C7F8E", cterm = 244 },
	log_level = "info",
	disable_inline_completion = false,
	disable_keymaps = false,
	-- condition = function() return false end,
})

-- =============================================================================
-- color / theme
-- =============================================================================
require("vague").setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi StatusLine guibg=NONE")

-- =============================================================================
-- Treesitter
-- =============================================================================
require("nvim-treesitter.configs").setup({
	ensure_installed = { "svelte", "python", "r", "bash", "lua" },
	highlight = { enable = true },
})

-- =============================================================================
-- Oil（<leader>e は常に CWD を開く）
-- =============================================================================
require("oil").setup({
	default_file_explorer = true,
	columns = { "icon", "permissions", "size", "mtime" },
	keymaps = {
		["go"] = { "actions.open_external", mode = "n", desc = "Open in external app" },
		["gr"] = function()
			local dir = require("oil").get_current_dir()
			if dir then
				vim.fn.jobstart({ "open", dir }, { detach = true })
			else
				vim.notify("No directory found", vim.log.levels.WARN)
			end
		end,
		["gy"] = { "actions.yank_entry", mode = "n", desc = "Copy file path" },
	},
})

map('n', '<leader>e', function()
	local cwd = vim.fn.fnameescape(vim.fn.getcwd())
	vim.cmd("Oil " .. cwd)
end, { noremap = true, silent = true, desc = "Open Oil in current working directory with preview" })

-- =============================================================================
-- コアキーマップ
-- =============================================================================
map('i', 'jk', '<Esc>', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<leader>re', ':restart<CR>')
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>bda', '<Cmd>:%bdelete!<CR>')
map('n', '<leader>bdd', '<Cmd>:%bdelete<CR>')
map('n', '<leader>q', '<Cmd>:quit<CR>')
map('n', '<leader>Q', '<Cmd>:wqa<CR>')

map('n', '<leader>xx', function()
	local line = vim.fn.getreg('"')
	vim.cmd('!' .. line)
end)
map('n', '<leader>xo', ':!open ')
map('n', '<leader>xr', ':!open -R ')

map({ 'n', 'v' }, '<leader>n', ':norm ')
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map('n', '<leader>lf', vim.lsp.buf.format, opts)
map('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')


-- =============================================================================
-- fzf-lua（重複 require の整理 + ランチャー群）
-- =============================================================================
local fzf = require('fzf-lua')
map('n', '<leader>ff', function() fzf.files() end)
map('n', '<leader>fb', function() fzf.buffers() end)
map('n', '<leader>fg', function() fzf.grep() end)
map('n', '<leader>fh', function() fzf.helptags() end)
map('n', '<leader>f/', function() fzf.blines() end)
map('n', '<leader>fy', function() fzf.registers() end, { desc = 'Yank history' })
map('n', '<leader>fr', function() fzf.resume() end, { desc = 'fzf: resume' })
map('n', '<leader>fo', function() fzf.oldfiles() end, { desc = 'fzf: oldfiles' })
map('n', '<leader>fm', function() fzf.marks() end, { desc = 'fzf: marks' })
map('n', 'gr', function() fzf.lsp_references({ jump_to_single_result = true }) end, { desc = 'LSP references' })
map('n', 'gd', function() fzf.lsp_definitions({ jump_to_single_result = true }) end, { desc = 'LSP definitions' })
map('n', 'gi', function() fzf.lsp_implementations({ jump_to_single_result = true }) end, { desc = 'LSP implementations' })

vim.keymap.set("i", "<C-f>",
	function() FzfLua.complete_path() end,
	{ silent = true, desc = "Fuzzy complete path" })

vim.keymap.set("n", "<leader>fp", function()
  require("my.project_picker").project_files()
end, { desc = "Search in Projects" })

vim.keymap.set("n", "<leader>fc", function()
  require("my.command_picker").run_command()
end, { desc = "Run favorite command (fzf)" })

-- =============================================================================
-- Slime (R用) : 「RREPL」ウィンドウ固定 + 自動起動 + 安定送信
-- =============================================================================
vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = 1
vim.g.slime_cell_delimiter = "##"
vim.g.slime_default_config = { socket_name = "default", target_pane = "RREPL.0" }

local R_START_CMD = "R --no-save --quiet" -- radian の場合は "radian"

local function ensure_RREPL_window()
	local wins = vim.fn.systemlist("tmux list-windows -F '#{window_name}' 2>/dev/null")
	local has = false
	for _, w in ipairs(wins) do
		if w == "RREPL" then
			has = true
			break
		end
	end
	if not has then
		vim.fn.system("tmux new-window -d -n RREPL '" .. R_START_CMD .. "'")
		vim.wait(900)
	else
		local pane_cmd = vim.fn.system("tmux display-message -p -t RREPL.0 '#{pane_current_command}'"):gsub("%s+$", "")
		if not (pane_cmd == "R" or pane_cmd == "radian") then
			vim.fn.system("tmux send-keys -t RREPL.0 '" .. R_START_CMD .. "' C-m")
			vim.wait(1200)
			pane_cmd = vim.fn.system("tmux display-message -p -t RREPL.0 '#{pane_current_command}'"):gsub("%s+$", "")
			if not (pane_cmd == "R" or pane_cmd == "radian") then
				vim.notify("tmux: RREPL.0 の起動確認に失敗しました", vim.log.levels.WARN)
			end
		end
	end
	vim.b.slime_config = { socket_name = "default", target_pane = "RREPL.0" }
end

local function slime_send_plug(plug)
	ensure_RREPL_window()
	vim.defer_fn(function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(plug, true, true, true), "n", false)
	end, 120)
end

-- 行送信 + 次行へ
map('n', '<leader>rl', function()
	ensure_RREPL_window()
	local n = vim.v.count1 -- 1行(デフォルト) or 数値カウント
	vim.fn['slime#send_lines'](n)
	vim.cmd('normal! j')
end, { desc = 'R: send line & move down' })



-- 選択範囲送信
map('x', '<leader>rv', function() slime_send_plug('<Plug>SlimeRegionSend') end, { desc = 'R: send visual selection' })

-- 段落送信
map('n', '<leader>rp', function()
	ensure_RREPL_window()
	vim.cmd('normal! vip')
	slime_send_plug('<Plug>SlimeRegionSend')
end, { desc = 'R: send paragraph' })

