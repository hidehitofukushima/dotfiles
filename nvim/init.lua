-- -----------------------------------------------------------------------------
-- 基本設定
-- -----------------------------------------------------------------------------

-- keymap
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.g.mapleader = " "            -- リーダーキーをスペースキーに設定
vim.g.slime_no_mappings = 1      -- デフォルトのキーマップを無効化
vim.g.slime_dont_ask_default = 1 -- デフォルトのターゲットを尋ねない
vim.g.slime_cell_delimiter = "##"
vim.g.slime_target = "tmux"      -- slimeのターゲットをtmuxに設定
vim.g.slime_default_config = {
	socket_name = "default",       -- tmuxのソケット名をフルパスで指定
	target_pane = ":.1",           -- ターゲットペインを指定
	send_timeout = 0,              -- 送信タイムアウトを無効化
}
-- -----------------------------------------------------------------------------
-- プラグイン管理 (built-in package manager)
-- -----------------------------------------------------------------------------
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/jpalardy/vim-slime" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/mason-org/mason.nvim" },
})



require "mason".setup()



-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.lsp.enable(
	{
		"lua_ls",
		"air",
		"r_language_server",
		"python",
		"svelte",
		"tinymist",
		"emmetls",
		"rust_analyzer",
		"clangd",
		"ruff",
		"glsl_analyzer",
		"haskell-language-server",
		"hlint",
		"intelephense"

	}
)

vim.cmd [[set completeopt+=menuone,noselect,popup]]
-- lsp
-- snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")
-- map('n', '<leader>lf', vim.lsp.buf.format)
-- map('i', '<C-e>', function() ls.expand_or_jump(1) end, { silent = true })
-- map({ 'i', 's' }, '<C-J>', function() ls.jump(1) end, { silent = true })
-- map({ 'i', 's' }, '<C-K>', function() ls.jump(-1) end, { silent = true })



-- color
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")


-- mappings

require "nvim-treesitter.configs".setup({
	ensure_installed = { "svelte", "python", "r", "bash", "lua" },
	highlight = { enable = true }
})




-- basics
map('i', 'jk', '<Esc>', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<C-n>', ':bnext<CR>', opts)     -- Normalモード: 次のバッファへ
map('n', '<C-p>', ':bprevious<CR>', opts) -- Normalモード: 前のバッファへ

-- system clipboard
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
map({ 'n', 'v' }, '<leader>c', ':')

-- file and buffers
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>bd', '<Cmd>:%bdelete!<CR>')
map('n', '<leader>q', '<Cmd>:quit<CR>')
map('n', '<leader>Q', '<Cmd>:wqa<CR>')
map('n', '<leader>o', ':update<CR> :source %<CR>', opts)

-- I use norm so much this makes sense
map({ 'n', 'v' }, '<leader>n', ':norm ')

-- quickly switch files with alternate / switch it
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map({ 'n', 'v', 'x' }, '<leader>m', ':move ')

-- slime
map('n', 'lkj', '<Plug>SlimeLineSend', opts)
map('x', 'lkj', '<Plug>SlimeRegionSend', opts)     -- 選択範囲の送信
map('n', ';lkj', 'vip<Plug>SlimeRegionSend', opts) -- 段落の送信
map('n', ';lkj', '<Plug>SlimeSendCell', opts)      -- セルの送信
-- telescope
local builtin = require('telescope.builtin')
map('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>pg', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>pb', builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>ph', builtin.help_tags, { desc = 'Telescope help tags' })

-- makeprg and make command
map('n', '<leader>mk', ':make<CR>', opts)
map('n', '<leader>qt', ':!qstat<CR>', opts)
vim.cmd([[autocmd FileType python setlocal makeprg=python3\ %]])
vim.cmd([[autocmd FileType r setlocal makeprg=Rscript\ %]])
vim.cmd([[autocmd FileType sh setlocal makeprg=cd\ $(dirname\ %)\ &&\ qsub\ %]])


-- Oil
require("oil").setup({
	default_file_explorer = true,
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},
})
map('n', '<leader>e', ':Oil --preview<CR>', opts)




-- other
map('n', '<leader>lf', vim.lsp.buf.format, opts)
map('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
map('n', '<C-c>', '<Cmd>Open .<CR>')
map('i', '<C-d>', function()
	return os.date('%Y-%m-%d')
end, { expr = true, noremap = true, desc = 'enter date' })





