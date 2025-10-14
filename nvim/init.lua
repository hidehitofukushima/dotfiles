-- =============================================================================
-- 基本設定 / Options & Globals
-- =============================================================================

-- キーマップショートカット
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- -----------------------------------------------------------------------------
-- 基本オプション
-- -----------------------------------------------------------------------------
vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.opt.winborder     = "rounded"
vim.opt.tabstop       = 2
vim.opt.shiftwidth    = 2
vim.opt.smartindent   = true
vim.opt.wrap          = false
vim.opt.cursorcolumn  = false
vim.opt.ignorecase    = true
vim.opt.number        = true
vim.opt.termguicolors = true
vim.opt.signcolumn    = "yes"

-- リーダーキー
vim.g.mapleader       = " "

-- -----------------------------------------------------------------------------
-- 行折り返し設定
-- -----------------------------------------------------------------------------
vim.opt.wrap          = true
vim.opt.breakindent   = true
vim.opt.showbreak     = string.rep(" ", 3)
vim.opt.linebreak     = true

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
-- 🔹追加2: 起動高速化 + Diagnostics 整備
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
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- 重複あり: 挙動維持のため残す
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = "main" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = 'https://github.com/ibhagwan/fzf-lua' },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/jpalardy/vim-slime" },
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/nvim-mini/mini.snippets" },
	{ src = "https://github.com/Kaiser-Yang/blink-cmp-dictionary" },
})

-- =============================================================================
-- LSP / 補完
-- =============================================================================

-- =============================================================================
-- LSP / 補完
-- =============================================================================
require("blink.cmp").setup({
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { "snippets", "lsp", "path", "buffer", "dictionary" },
    providers = {
      dictionary = {
        module = "blink-cmp-dictionary",
        name = "Dict",
        min_keyword_length = 3,
        async = true,
        score_offset = -1000,
        max_items = 5,
        opts = { dictionary_files = { "/usr/share/dict/words" } },
      },
    },
  },
  -- ★ここだけ変更：LuaSnip を明示
  snippets = { preset = "luasnip" },
  keymap = {
    preset = "super-tab",
    ["<C-q>"] = { 'show', 'show_documentation', 'hide_documentation' },
		["<C-e>"] = { "hide" },
  },
  signature = { enabled = true },
  cmdline = { keymap = { preset = "super-tab" } },
})

-- ★LuaSnip の設定と VSCode 形式スニペットの遅延ロード
require("luasnip").config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})
require("luasnip.loaders.from_vscode").lazy_load()

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "bash-language-server",
    "lua_ls",
    "basedpyright",
    "r_language_server",
    "r-languageserver",
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
--
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
	condition = function() return false end,
})

-- =============================================================================
-- color / theme
-- =============================================================================
require("vague").setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- =============================================================================
-- Treesitter
-- =============================================================================
require("nvim-treesitter.configs").setup({
	ensure_installed = { "svelte", "python", "r", "bash", "lua" },
	highlight = { enable = true },
})

-- =============================================================================
-- Oil
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

map('n', '<leader>e', ":Oil --preview<CR>",
	{ noremap = true, silent = true, desc = "Open Oil file browser with preview" })

-- =============================================================================
-- コアキーマップ
-- =============================================================================
map('n', '<leader>re', ':restart<CR>')
map('i', 'jk', '<Esc>', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>bda', '<Cmd>:%bdelete!<CR>')
map('n', '<leader>bdd', '<Cmd>:%bdelete<CR>')
map('n', '<leader>q', '<Cmd>:quit<CR>')
map('n', '<leader>Q', '<Cmd>:wqa<CR>')
map('n', '<leader>o', ':update<CR> :source %<CR>', opts)
map({ 'n', 'v' }, '<leader>n', ':norm ')
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map({ 'n', 'v', 'x' }, '<leader>m', ':move ')
map('n', '<leader>lf', vim.lsp.buf.format, opts)
map('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')


-- =============================================================================
-- makeprg / 外部コマンド
-- =============================================================================
map('n', '<leader>kk', ':update<CR> :make<CR>', opts)
map('n', '<leader>qt', ':!qstat<CR>', opts)

-- 🔹追加3: autocmdグループ化（重複登録防止）
vim.api.nvim_create_augroup("user_makeprg", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "user_makeprg",
	pattern = "python",
	command = "setlocal makeprg=python3\\ \\%",
})
vim.api.nvim_create_autocmd("FileType", {
	group = "user_makeprg",
	pattern = "r",
	command = "setlocal makeprg=Rscript\\ \\%",
})
vim.api.nvim_create_autocmd("FileType", {
	group = "user_makeprg",
	pattern = "sh",
	command = "setlocal makeprg=cd\\ $(dirname\\ \\%)\\ \\&\\&\\ qsub\\ \\%",
})

-- =============================================================================
-- fzf-lua
-- =============================================================================
map('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>")
map('n', '<leader>fg', "<cmd>lua require('fzf-lua').grep()<CR>")
map('n', '<leader>fh', "<cmd>lua require('fzf-lua').helptags()<CR>")
map('n', '<leader>/', "<cmd>lua require('fzf-lua').blines()<CR>")


-- =============================================================================
-- Slime (R用) : 「RREPL」ウィンドウ固定 + 自動起動 + 安定送信
-- =============================================================================

-- 前提（未設定でも上書きして無害）
vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = 1
vim.g.slime_cell_delimiter = "##"
vim.g.slime_default_config = { socket_name = "default", target_pane = "RREPL.0" } -- ★固定先

-- ★起動コマンド（radian派は "radian" に変更）
local R_START_CMD = "R --no-save --quiet"

-- 「RREPL.0」にR/radianがいなければ作る/起動する（非アタッチ作成）
local function ensure_RREPL_window()
	-- 既に "RREPL" ウィンドウがあるか？
	local wins = vim.fn.systemlist("tmux list-windows -F '#{window_name}' 2>/dev/null")
	local has = false
	for _, w in ipairs(wins) do
		if w == "RREPL" then
			has = true
			break
		end
	end

	if not has then
		-- 画面を切り替えずに新規作成してR起動
		vim.fn.system("tmux new-window -d -n RREPL '" .. R_START_CMD .. "'")
		vim.wait(900) -- 起動待ち
	else
		-- pane 0 のコマンド確認し、Rがいなければ起動
		local pane_cmd = vim.fn.system("tmux display-message -p -t RREPL.0 '#{pane_current_command}'"):gsub("%s+$", "")
		if not (pane_cmd == "R" or pane_cmd == "radian") then
			vim.fn.system("tmux send-keys -t RREPL.0 '" .. R_START_CMD .. "' C-m")
			vim.wait(1200)
			-- 起動確認（再取得）
			pane_cmd = vim.fn.system("tmux display-message -p -t RREPL.0 '#{pane_current_command}'"):gsub("%s+$", "")
			if not (pane_cmd == "R" or pane_cmd == "radian") then
				vim.notify("tmux: RREPL.0 の起動確認に失敗しました", vim.log.levels.WARN)
			end
		end
	end

	-- このバッファの送信先を常に RREPL.0 に固定（b: が g: より優先）
	vim.b.slime_config = { socket_name = "default", target_pane = "RREPL.0" }
end

-- <Plug> を送るヘルパ（RREPLを必ず用意してから少し遅延して送信）
local function slime_send_plug(plug)
	ensure_RREPL_window()
	vim.defer_fn(function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(plug, true, true, true), "n", false)
	end, 120)
end

-- ---- マッピング ----

-- 1) 行送信 + 次行へ（v:count1対応）
vim.keymap.set('n', '<leader>rl', function()
	ensure_RREPL_window()
	local n = vim.v.count1 -- 1行(デフォルト) or 数値カウント
	vim.fn['slime#send_lines'](n)
	vim.cmd('normal! j')
end, { desc = 'R: send line & move down' })

-- 2) 選択範囲送信 
vim.keymap.set('x', '<leader>rv', function() slime_send_plug('<Plug>SlimeRegionSend') end,
	{ desc = 'R: send visual selection' })

-- 3) 段落送信
vim.keymap.set('n', '<leader>rp',
	function()
		ensure_RREPL_window()
		vim.cmd('normal! vip')
		slime_send_plug('<Plug>SlimeRegionSend')
	end, { desc = 'R: send paragraph' })

