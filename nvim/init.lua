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
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/l3mon4d3/luasnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/kaiser-yang/blink-cmp-dictionary" },

})

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
-- Oil（<leader>e は常に CWD を開く）
-- =============================================================================
require("oil").setup({
	default_file_explorer = true,
	columns = { "icon", "permissions", "size", "mtime" },
	keymaps = {
		["go"] = { "actions.open_external", mode = "n", desc = "Open in external app" },
		["gy"] = { "actions.yank_entry", mode = "n", desc = "Copy file path" },
		["gr"] = function()
			local dir = require("oil").get_current_dir()
			if dir then
				vim.fn.jobstart({ "open", dir }, { detach = true })
			else
				vim.notify("No directory found", vim.log.levels.WARN)
			end
		end,
	},
})

-- leader e で普通に Oil を　previewつきで開く
map('n', '<leader>e', '<Cmd>Oil --preview<CR>')

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
-- コアキーマップ
-- =============================================================================
map('i', 'jk', '<Esc>', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<leader>re', ':restart<CR>')
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>m', '<Cmd>e ~/memo.md<CR>')
map('n', '<leader>i', '<Cmd>e ~/.config/nvim/init.lua<CR>')
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
map('n', '<leader>z', '<cmd>ZenMode<CR>')


