-- -----------------------------------------------------------------------------
-- 基本設定
-- -----------------------------------------------------------------------------
vim.opt.tgc = false                             -- タブのジャンプでカーソルを移動させない
vim.opt.wrap = true 
vim.opt.ignorecase = true                       -- 大文字と小文字を区別しない
vim.opt.smartcase = true                        -- ただし、検索文字に大文字が含まれている場合は区別する (スマートケース)
vim.o.number = true                             -- 行番 を表示
vim.o.shiftwidth = 2                            -- インデントの幅をスペース4つ分に設定
vim.o.wrap = false                              -- 長い行を折り返さない
vim.o.tabstop = 2                               -- タブの幅をスペース4つ分に設定
vim.o.swapfile = false                          -- スワップファイルを作成しない
vim.g.mapleader = " "                           -- リーダーキーをスペースキーに設定
vim.o.clipboard = "unnamedplus"                 -- システムクリップボードを使用
vim.g.slime_no_mappings = 1                      -- デフォルトのキーマップを無効化
vim.g.slime_dont_ask_default = 1                 -- デフォルトのターゲットを尋ねない
vim.g.slime_cell_delimiter = "##"
vim.g.slime_target = "tmux"                     -- slimeのターゲットをtmuxに設定
vim.g.slime_default_config = {
	socket_name = "default", -- tmuxのソケット名をフルパスで指定
	target_pane = ":.1",                          -- ターゲットペインを指定 
	-- (ターゲットペインは、ファイル名のみでなく、ファイル名とパスも含めることができます)
	send_timeout = 0,                             -- 送信タイムアウトを無効化
}
-- -----------------------------------------------------------------------------
-- プラグイン管理 (built-in package manager)
-- -----------------------------------------------------------------------------
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/jpalardy/vim-slime" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/ThePrimeagen/harpoon" },
})

-- -----------------------------------------------------------------------------
-- 各機能の設定とキーマップ (configurations & keymaps)
-- -----------------------------------------------------------------------------
require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<C-k>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-l>",
  },
  ignore_filetypes = { cpp = true }, -- or { "cpp", }
  color = {
    suggestion_color = "#3C7F8E",
    cterm = 244,
  },
  log_level = "info", -- set to "off" to disable logging completely
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false, -- disables built in keymaps for more manual control
  condition = function()
    return false
  end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
})

require("bufferline").setup()

-- キーマップ
--
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "lkj", "<Plug>SlimeLineSend", opts)
keymap("x", "lkj", "<Plug>SlimeRegionSend", opts) -- 選択範囲の送信
keymap("n", ";lkj", "vip<Plug>SlimeRegionSend", opts) -- 段落の送信
keymap("n", ";lkj", "<Plug>SlimeSendCell", opts) -- セルの送信
keymap("n", "<leader>w", ":bd<CR>", opts)
keymap("n", "<leader>ww", ":bd!<CR>", opts)
keymap("n", "<leader>s", ":write<CR>", opts)
keymap("n", "<leader>ss", ":update<CR> :source %<CR>", opts)
keymap("n", "zz", ":q!<CR>", opts)
keymap("n", "<C-n>", ":bnext<CR>", opts)          -- Normalモード: 次のバッファへ
keymap("i", "<C-n>", "<C-o>:bnext<CR>", opts)     -- Insertモード: 次のバッファへ
keymap("n", "<C-p>", ":bprevious<CR>", opts)      -- Normalモード: 前のバッファへ
keymap("i", "<C-p>", "<C-o>:bprevious<CR>", opts) -- Insertモード: 前のバッファへ
keymap("n", "<leader>v", ":enew<CR>", opts)
keymap("n", "<leader>e", ":Oil --preview<CR>", opts)
keymap("i", "jk", "<Esc>", opts)
keymap("n", "<leader>lf", vim.lsp.buf.format, opts)
keymap("n", "<leader>m", ":e ~/memo.md<CR>", opts)
keymap("n", "<leader>k", ":make<CR>",opts)
keymap("n", "<leader>q", "!qstat<CR>", opts)
-- インサートモードで <C-d> を押すと 'YYYY-MM-DD' 形式の日付を挿入する
vim.keymap.set('i', '<C-d>', function()
  return os.date('%Y-%m-%d')
end, { expr = true, noremap = true, desc = '今日の日付を挿入' })
vim.cmd([[autocmd FileType python setlocal makeprg=python3\ %]])
vim.cmd([[autocmd FileType R setlocal makeprg=Rscript\ %]])
vim.cmd([[autocmd FileType sh setlocal makeprg=cd\ $(dirname\ %)\ &&\ qsub\ %]])
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
vim.keymap.set("n", "<M-t>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
vim.keymap.set("n", "<M-n>", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
vim.keymap.set("n", "<M-s>", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")

require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
  default_file_explorer = true,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  -- Window-local options to use for oil buffers
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = false,
  -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
  skip_confirm_for_simple_edits = true,
 -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  -- (:help prompt_save_on_select_new_entry)
  prompt_save_on_select_new_entry = true,
  -- Oil will automatically delete hidden buffers after this delay
  -- You can set the delay to false to disable cleanup entirely
  -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
  cleanup_delay_ms = 2000,
  lsp_file_methods = {
    -- Enable or disable LSP file operations
    enabled = true,
    -- Time to wait for LSP file operations to complete before skipping
    timeout_ms = 1000,
    -- Set to true to autosave buffers that are updated with LSP willRenameFiles
    -- Set to "unmodified" to only save unmodified buffers
    autosave_changes = false,
  },
  -- Constrain the cursor to the editable parts of the oil buffer
  -- Set to `false` to disable, or "name" to keep it on the file names
  constrain_cursor = "editable",
  -- Set to true to watch the filesystem for changes and reload oil
  watch_for_changes = false,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gh"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
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
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = false,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      local m = name:match("^%.")
      return m ~= nil
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
    -- Sort file names with numbers in a more intuitive order for humans.
    -- Can be "fast", true, or false. "fast" will turn it off for large directories.
    natural_order = "fast",
    -- Sort file and directory names case insensitive
    case_insensitive = false,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
    -- Customize the highlight group for the file name
    highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
      return nil
    end,
  },
})

-- telescope
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
