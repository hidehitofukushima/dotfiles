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
})

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
				"##################################################################",
				"# ",
				"##################################################################",
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
		["gh"] = { "actions.open_external", mode = "n", desc = "Open in external app" },
		["gj"] = function()
			local dir = require("oil").get_current_dir()
			if dir then
				vim.fn.jobstart({ "open", dir }, { detach = true })
			else
				vim.notify("No directory found", vim.log.levels.WARN)
			end
		end,
		["yp"] = { "actions.yank_entry", mode = "n", desc = "Copy file path" },
	},
})

map('n', '<leader>e', function()
	local cwd = vim.fn.fnameescape(vim.fn.getcwd())
	vim.cmd("Oil " .. cwd .. " --preview")
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
map('n', '<leader>oo', ':!open ')
map('n', '<leader>or', ':!open -R ')
-- map('n', '<leader>x', ':!')
map('n', '<leader>x', function()
	local line = vim.fn.getreg('"')
	vim.cmd('!' .. line)
end)
map({ 'n', 'v' }, '<leader>n', ':norm ')
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map('n', '<leader>lf', vim.lsp.buf.format, opts)
map('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- =============================================================================
-- makeprg / 外部コマンド（autocmd をグループ化し重複防止）
-- =============================================================================
map('n', '<leader>kk', ':update<CR> :make<CR>', { noremap = true, silent = true })

map('n', '<leader>qt', ':!qstat<CR>', opts)

local aug = vim.api.nvim_create_augroup("user_makeprg", { clear = true })
vim.api.nvim_create_autocmd("FileType",
	{ group = aug, pattern = "python", command = "setlocal makeprg=python3\\ \\%\\ \\>\\ out" })
vim.api.nvim_create_autocmd("FileType",
	{ group = aug, pattern = "r", command = "setlocal makeprg=Rscript\\ \\%\\ \\>\\ out" })
-- vim.api.nvim_create_autocmd("FileType",	{ group = aug, pattern = "sh", command = "setlocal makeprg=cd\\ $(dirname\\ \\%)\\ \\&\\&\\ qsub\\ \\%" })
vim.api.nvim_create_autocmd("FileType",
	{ group = aug, pattern = "sh", command = "setlocal makeprg=bash\\ \\%\\ \\>\\ out" })

-- =============================================================================
-- fzf-lua（重複 require の整理 + ランチャー群）
-- =============================================================================
local fzf = require('fzf-lua')

-- map('n', '<leader>ff', function() fzf.files() end)
-- map('n', '<leader>ff', function()
-- 	fzf.files({
-- 		actions = {
-- 			["ctrl-o"] = function(selected)
-- 				if not selected or #selected == 0 then return end
-- 				local full = to_fullpath(selected[1])
-- 				vim.cmd("!open " .. full)
-- 			end
-- 		}
-- 	}) end)
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
map('n', '<leader>fq', function()
	require('fzf-lua').quickfix()
end, { desc = 'FZF: Quickfix list' })

-- ---- コマンド履歴ランチャー ----
map('n', '<leader>fc', function()
	local history = vim.fn.execute('history cmd')
	local lines = {}
	for line in history:gmatch("[^\r\n]+") do
		local cmd = line:match("%d+%s+(.*)")
		if cmd then table.insert(lines, cmd) end
	end
	fzf.fzf_exec(lines, {
		prompt = 'Cmd> ',
		previewer = false,
		actions = {
			['default'] = function(selected)
				local cmd = selected and selected[1]
				if not cmd then return end
				vim.cmd(cmd)
				vim.notify('Executed: ' .. cmd, vim.log.levels.INFO)
			end,
		},
	})
end, { desc = 'fzf: command history launcher' })

-- ---- 検索履歴ランチャー ----
map('n', '<leader>fs', function()
	local hist = vim.fn.execute('history search')
	local lines = {}
	for l in hist:gmatch("[^\r\n]+") do
		local s = l:match("%d+%s+(.*)")
		if s then table.insert(lines, s) end
	end
	fzf.fzf_exec(lines, {
		prompt = '/search> ',
		actions = {
			['default'] = function(selected)
				local word = selected and selected[1]
				if not word then return end
				vim.cmd('/' .. word)
			end,
		},
	})
end, { desc = 'fzf: search history' })

-- =============================================================================
-- fzf-lua: 絶対パスピッカー（任意ディレクトリから探して挿入/ヤンク）
-- =============================================================================
local actions = require('fzf-lua.actions') -- 今後の拡張用に保持

-- 設定（tmux-sessionizerライク）
local TS_SEARCH_PATHS = {
	"/Volumes:2",
	"~/",
	"~/Desktop:2",
	"~/Desktop/Projects_wgs",
	"~/Desktop/Projects_wgs_v2",
	"~/Desktop/Projects_wgs_deprecated",
	"~/Desktop/Projects_Other",
}
local TS_EXTRA_SEARCH_PATHS = {
	-- "~/.config:2",
	-- "~/Git:3",
}
local TS_MAX_DEPTH = 1
local INCLUDE_CUSTOM_INPUT = true
local DEBUG = true
local function dump(label, v) if not DEBUG then return end end

local function expanduser(p) return vim.fn.expand(p) end

local function parse_entry(entry)
	local path, depth = entry:match("^(.*):(%d+)$")
	if path and depth then
		return expanduser(path), tonumber(depth)
	else
		return expanduser(entry), nil
	end
end

local function find_dirs_under(path, depth)
	local d = depth or TS_MAX_DEPTH
	if vim.fn.isdirectory(path) ~= 1 then return {} end
	local cmd = { "find", path, "-mindepth", "1", "-maxdepth", tostring(d), "-path", "*/.git", "-prune", "-o", "-type", "d",
		"-print" }
	local list = vim.fn.systemlist(cmd)
	if vim.v.shell_error ~= 0 then return {} end
	return list
end

local function build_dir_candidates()
	local merged = {}
	for _, v in ipairs(TS_SEARCH_PATHS) do table.insert(merged, v) end
	for _, v in ipairs(TS_EXTRA_SEARCH_PATHS) do table.insert(merged, v) end
	local set, out = {}, {}
	for _, entry in ipairs(merged) do
		local base, depth = parse_entry(entry)
		dump("parse_entry", { entry = entry, base = base, depth = depth or TS_MAX_DEPTH })
		for _, d in ipairs(find_dirs_under(base, depth)) do
			if vim.fn.isdirectory(d) == 1 and not set[d] then
				set[d] = true
				table.insert(out, d)
			end
		end
	end
	table.sort(out)
	dump("dir_candidates.count", #out)
	return out
end

local function to_fullpath(cwd, path_like)
	if path_like:sub(1, 1) == "/" then
		return vim.fn.fnamemodify(path_like, ":p")
	else
		return vim.fn.fnamemodify(cwd .. "/" .. path_like, ":p")
	end
end

local function notify_ok(msg) vim.notify(msg, vim.log.levels.INFO) end
local function notify_ng(msg) vim.notify(msg, vim.log.levels.ERROR) end
local function notify_wl(msg) vim.notify(msg, vim.log.levels.WARN) end

local function open_file(full, cmd)
	local esc = vim.fn.fnameescape(full)
	vim.cmd((cmd or "edit") .. " " .. esc)
	notify_ok("Opened: " .. full)
end

local function copy_fullpath(full)
	vim.fn.setreg("+", full)
	notify_ok("Copied: " .. full)
end

local function pick_file_under(dir)
	dump("files.cwd", dir)
	fzf.files({
		cwd = dir,
		prompt = "Files in " .. dir .. "> ",
		hidden = true,
		git_icons = false,
		file_icons = false,
		fd_opts = "--color=never --type f --hidden --follow --exclude .git",
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then return notify_wl("No file selected") end
				local full = to_fullpath(dir, selected[1])
				copy_fullpath(full)
			end,
			["ctrl-y"] = function(selected)
				if not selected or #selected == 0 then return notify_wl("No file selected") end
				local full = to_fullpath(dir, selected[1])
				open_file(full, "edit")
			end,
			["ctrl-s"] = function(selected)
				if not selected or #selected == 0 then return end
				local full = to_fullpath(dir, selected[1])
				open_file(full, "split")
			end,
			["ctrl-v"] = function(selected)
				if not selected or #selected == 0 then return end
				local full = to_fullpath(dir, selected[1])
				open_file(full, "vsplit")
			end,
			["ctrl-t"] = function(selected)
				if not selected or #selected == 0 then return end
				local full = to_fullpath(dir, selected[1])
				open_file(full, "tabedit")
			end,
		},
	})
end

local function pick_root_then_files()
	local list = build_dir_candidates()
	if INCLUDE_CUSTOM_INPUT then table.insert(list, 1, "(custom) Enter a path...") end
	if #list == 0 then return notify_ng("No directories found from TS_SEARCH_PATHS") end
	fzf.fzf_exec(list, {
		prompt = "Select root> ",
		fzf_opts = { ["--reverse"] = true },
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then return notify_wl("No selection") end
				local dir = selected[1]
				if INCLUDE_CUSTOM_INPUT and dir:match("^%(") then
					dir = vim.fn.input("Absolute path: ", "/", "dir")
					if dir == nil or dir == "" then return notify_wl("Empty path") end
				end
				dir = expanduser(dir)
				if vim.fn.isdirectory(dir) ~= 1 then return notify_ng("Not a directory: " .. dir) end
				notify_ok("Root: " .. dir)
				pick_file_under(dir)
			end,
		},
	})
end

map('n', '<leader>fp', function()
	pick_root_then_files()
end, { desc = "FZF: TS_SEARCH_PATHS → file (Enter=open, C-y=copy)" })

map('n', '<leader>ff', function()
	fzf.files({
		actions = {
			["ctrl-o"] = function(selected)
				if not selected or #selected == 0 then return end
				local full = to_fullpath(selected[1])
				vim.cmd("!open " .. full)
			end
		}
	})
end)
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

-- =============================================================================
-- fzf-lua: ディレクトリピッカー（任意ディレクトリを選択→コピー/開く/移動）
-- =============================================================================
-- 既存のユーティリティ関数や設定（build_dir_candidates, to_fullpath など）が上で定義済み前提。
-- "root を選ぶ" → "その配下のディレクトリを選ぶ" の2段構え。


-- dir 配下のディレクトリを列挙
local function list_dirs_under(dir, maxdepth)
	local depth = tostring(maxdepth or 3)
	if vim.fn.isdirectory(dir) ~= 1 then return {} end


	-- fd があれば高速、なければ find
	local has_fd = (vim.fn.executable('fd') == 1)
	local list
	if has_fd then
		list = vim.fn.systemlist({
			'fd', '--hidden', '--follow', '--exclude', '.git', '--type', 'd',
			'--max-depth', depth, '.', dir,
		})
	else
		list = vim.fn.systemlist({
			'find', dir, '-mindepth', '1', '-maxdepth', depth,
			'-path', '*/.git', '-prune', '-o', '-type', 'd', '-print',
		})
	end
	if vim.v.shell_error ~= 0 then return {} end
	table.sort(list)
	return list
end


-- ディレクトリピッカー本体（2段目）
local function pick_dir_under(dir)
	local dirs = list_dirs_under(dir, 5) -- 深さは好みで
	if #dirs == 0 then return vim.notify('No subdirectories', vim.log.levels.WARN) end
	require('fzf-lua').fzf_exec(dirs, {
		prompt = 'Dirs in ' .. dir .. '> ',
		fzf_opts = { ['--reverse'] = true },
		actions = {
			-- 既定: フルパスをクリップボードにコピー
			['default'] = function(selected)
				if not selected or #selected == 0 then return end
				local full = vim.fn.fnamemodify(selected[1], ':p')
				vim.fn.setreg('+', full)
				vim.notify('Copied: ' .. full, vim.log.levels.INFO)
			end,
			-- Ctrl-y: Oil でそのディレクトリを開く
			['ctrl-y'] = function(selected)
				if not selected or #selected == 0 then return end
				local full = vim.fn.fnamemodify(selected[1], ':p')
				local esc = vim.fn.fnameescape(full)
				vim.cmd('Oil ' .. esc .. ' --preview')
			end,
			-- Ctrl-c: カレントディレクトリ（:tcd）を切り替える
			['ctrl-c'] = function(selected)
				if not selected or #selected == 0 then return end
				local full = vim.fn.fnamemodify(selected[1], ':p')
				local esc = vim.fn.fnameescape(full)
				vim.cmd('tcd ' .. esc)
				vim.notify('tcd → ' .. full, vim.log.levels.INFO)
			end,
			-- Ctrl-t: 新しいタブで Oil を開く
			['ctrl-t'] = function(selected)
				if not selected or #selected == 0 then return end
				local full = vim.fn.fnamemodify(selected[1], ':p')
				local esc = vim.fn.fnameescape(full)
				vim.cmd('tabnew | Oil ' .. esc .. ' --preview')
			end,
		},
	})
end


-- 1段目: 起点ディレクトリ選択（既存の build_dir_candidates を流用）
local function pick_root_then_dirs()
	local list = build_dir_candidates()
	if INCLUDE_CUSTOM_INPUT then table.insert(list, 1, '(custom) Enter a path...') end
	if #list == 0 then return vim.notify('No directories from TS_SEARCH_PATHS', vim.log.levels.ERROR) end
	require('fzf-lua').fzf_exec(list, {
		prompt = 'Select root> ',
		fzf_opts = { ['--reverse'] = true },
		actions = {
			['default'] = function(selected)
				if not selected or #selected == 0 then return end
				local dir = selected[1]
				if INCLUDE_CUSTOM_INPUT and dir:match('^%(') then
					dir = vim.fn.input('Absolute path: ', '/', 'dir')
					if dir == nil or dir == '' then return end
				end
				dir = vim.fn.expand(dir)
				if vim.fn.isdirectory(dir) ~= 1 then
					return vim.notify('Not a directory: ' .. dir, vim.log.levels.ERROR)
				end
				pick_dir_under(dir)
			end,
		},
	})
end


-- キーマップ: <leader>fd （files の兄弟として配置）
map('n', '<leader>fP', function()
	pick_root_then_dirs()
end, { desc = 'FZF: pick directory → copy/open/tcd' })
