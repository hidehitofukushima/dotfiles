-- =============================================================================
-- 基本設定 / Options & Globals（整理版）
-- =============================================================================
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
-- 行折り返し設定（※wrap は true を採用）
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
-- プラグイン管理
-- =============================================================================
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/jpalardy/vim-slime" },
	{ src = "https://github.com/Kaiser-Yang/blink-cmp-dictionary" },
	{ src = "https://github.com/petertriho/nvim-scrollbar" },
	{ src = "https://github.com/folke/tokyonight.nvim" },

})

-- =============================================================================
-- Scrollbar
-- =============================================================================
require("scrollbar").setup({
	handle = { color = "#FFFFFF" },
})

-- =============================================================================
-- Color / Theme
-- =============================================================================

require("tokyonight").setup({
  style = "night",  -- "storm" | "night" | "moon" | "day"
  transparent = true,
  terminal_colors = true,
  styles = { comments = { italic = false } },
})
vim.cmd("colorscheme tokyonight")
-- vim.cmd(":hi StatusLine guibg=NONE")

-- =============================================================================
-- Treesitter
-- =============================================================================
require("nvim-treesitter.configs").setup({
	ensure_installed = { "svelte", "python", "r", "bash", "lua" },
	highlight = { enable = true },
})

-- =============================================================================
-- LSP / 補完（blink.cmp + LuaSnip）
-- =============================================================================
require("blink.cmp").setup({
	completion = { documentation = { auto_show = true, auto_show_delay_ms = 500 } },
	sources = {
		default = { "snippets", "lsp", "path", "buffer" },
		providers = {
			path = {
				opts = { get_cwd = function(_) return vim.fn.getcwd() end },
			},
		},
	},
	snippets = { preset = "luasnip" },
	keymap = {
		preset = "super-tab",
		["<C-q>"] = { 'show', 'show_documentation', 'hide_documentation' },
		["<C-e>"] = { "hide" },
		["<Tab>"] = { "accept", "snippet_forward", "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		["<CR>"] = { "fallback" },
	},
	signature = { enabled = true },
	fuzzy = { prebuilt_binaries = { force_version = "v1.7.0" } },
})

local ls = require("luasnip")
require("luasnip").config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
})
require("luasnip.loaders.from_vscode").lazy_load()

-- LuaSnip keymap
vim.keymap.set({ "i", "s" }, "<C-j>", function() if ls.expand_or_jumpable() then ls.expand_or_jump() end end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-k>", function() if ls.jumpable(-1) then ls.jump(-1) end end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-l>", function() if ls.choice_active() then ls.change_choice(1) end end, { silent = true })

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
-- R用 %>% / <- スニペット
-- =============================================================================
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("r", {
	s({ trig = "zzp", dscr = "magrittr pipe", wordTrig = true, snippetType = "autosnippet" }, t("%>%")),
	s({ trig = "zzl", dscr = "left assignment", wordTrig = true, snippetType = "autosnippet" }, t("<-")),
}, { key = "r-ops-auto" })

ls.add_snippets("all", {
	s({ trig = "hdr", dscr = "header", wordTrig = true },
		fmt([[
###########################################
# {}
###########################################
{}
]], { i(1), i(2) })
	),
})

-- =============================================================================
-- Supermaven
-- =============================================================================
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<C-¥>",
		clear_suggestion  = "<C-^>",
		accept_word       = "<C-]>",
		accept_line       = "<C-[>",
	},
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
	vim.cmd("Oil " .. cwd .. " --preview")
end, { noremap = true, silent = true, desc = "Open Oil in current working directory with preview" })

-- =============================================================================
-- fzf-lua
-- =============================================================================
local fzf = require('fzf-lua')
local actions = require("fzf-lua").actions
local function first(sel) return type(sel) == "table" and sel[1] or sel end

require('fzf-lua').setup({
	previewers = {
		builtin = {
			extensions = {
				["png"] = { "chafa", "--symbols=block", "--fill=block", "--scale=fill", "--color-space=rgb", "--dither=fs", "{file}" },
				["svg"] = { "chafa", "--symbols=block", "--fill=block", "--scale=fill", "--color-space=rgb", "--dither=fs", "{file}" },
				["jpg"] = { "chafa", "--symbols=block", "--fill=block", "--scale=fill", "--color-space=rgb", "--dither=fs", "{file}" },
			},
		},
	},
})

map('n', '<leader>ff', function()
	fzf.files({
		actions = {
			["default"] = actions.file_edit,
			["ctrl-y"] = function(selected)
				local path = vim.fn.trim(first(selected))
				vim.fn.setreg("+", path)
				vim.fn.setreg('"', path)
				vim.notify("📋 Copied: " .. path)
			end,
			["ctrl-o"] = function(selected)
				local path = vim.fn.trim(first(selected))
				vim.fn.jobstart({ "open", path }, { detach = true })
				vim.notify("🚀 Opened: " .. path)
			end,
			["ctrl-r"] = function(selected)
				local path = vim.fn.trim(first(selected))
				vim.fn.jobstart({ "open", "-R", path }, { detach = true })
				vim.notify("📂 Finderで表示: " .. path)
			end,
		},
	})
end)
map('n', '<leader>fb', function() fzf.buffers() end)
map('n', '<leader>fg', function() fzf.grep() end)
map('n', '<leader>fh', function() fzf.helptags() end)
map('n', '<leader>f/', function() fzf.blines() end)
map('n', '<leader>fy', function() fzf.registers() end)
map('n', '<leader>fr', function() fzf.resume() end)
map('n', '<leader>fo', function() fzf.oldfiles() end)
map('n', '<leader>fm', function() fzf.marks() end)
map('n', 'gr', function() fzf.lsp_references({ jump_to_single_result = true }) end)
map('n', 'gd', function() fzf.lsp_definitions({ jump_to_single_result = true }) end)
map('n', 'gi', function() fzf.lsp_implementations({ jump_to_single_result = true }) end)

vim.keymap.set("i", "<C-f>", function() FzfLua.complete_path() end)
vim.keymap.set("n", "<leader>fp", function() require("my.project_picker").project_files() end)
vim.keymap.set("n", "<leader>fc", function() require("my.command_picker").run_command() end)

-- =============================================================================
-- Slime (R用) : RREPLウィンドウ固定 + 自動起動 + 安定送信
-- =============================================================================
vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = 1
vim.g.slime_cell_delimiter = "##"
vim.g.slime_default_config = { socket_name = "default", target_pane = "RREPL.0" }

local R_START_CMD = "R --no-save --quiet"

local function ensure_RREPL_window()
	local wins = vim.fn.systemlist("tmux list-windows -F '#{window_name}' 2>/dev/null")
	local has = false
	for _, w in ipairs(wins) do
		if w == "RREPL" then has = true break end
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

map('n', '<leader>rl', function()
	ensure_RREPL_window()
	local n = vim.v.count1
	vim.fn['slime#send_lines'](n)
	vim.cmd('normal! j')
end)

map('x', '<leader>rv', function() slime_send_plug('<Plug>SlimeRegionSend') end)
map('n', '<leader>rp', function()
	ensure_RREPL_window()
	vim.cmd('normal! vip')
	slime_send_plug('<Plug>SlimeRegionSend')
end)

-- =============================================================================
-- コアキーマップ
-- =============================================================================
map('i', 'jk', '<Esc>', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<leader>re', ':restart<CR>')
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>m', '<Cmd>e ~/memo.md<CR>')
map('n', '<leader>bda', '<Cmd>:%bdelete!<CR>')
map('n', '<leader>bdd', '<Cmd>:%bdelete<CR>')
map('n', '<leader>q', '<Cmd>:quit<CR>')
map('n', '<leader>Q', '<Cmd>:wqa<CR>')
map('n', '<leader>xx', function() local line = vim.fn.getreg('"') vim.cmd('!' .. line) end)
map('n', '<leader>xo', ':!open ')
map('n', '<leader>xr', ':!open -R ')
map({ 'n', 'v' }, '<leader>n', ':norm ')
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map('n', '<leader>lf', vim.lsp.buf.format, opts)
map('n', '<C-g>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')


-- =============================================================================
-- LSP 一時停止 / 再開トグル
-- =============================================================================
local lsp_active = true

vim.api.nvim_create_user_command("LspToggle", function()
  if lsp_active then
    -- 現在動作中のクライアントを停止
    for _, client in pairs(vim.lsp.get_active_clients()) do
      client.stop(true)
    end
    vim.notify("🛑 LSP stopped", vim.log.levels.INFO)
  else
    -- 再度アタッチ（ファイルタイプごとの LSP を再起動）
    vim.cmd("edit")  -- ファイルを再読み込みしてLSP起動をトリガー
    vim.notify("🚀 LSP restarted", vim.log.levels.INFO)
  end
  lsp_active = not lsp_active
end, {})


vim.keymap.set('n', '<leader>lt', ':LspToggle<CR>', { noremap = true, silent = true, desc = "Toggle LSP on/off" })

