-- === Project template creator ===
-- Neovim 0.9〜0.10 どちらでも動くように実装
local uv = vim.loop
local fs_join = vim.fs and vim.fs.joinpath or function(...)
  return table.concat({ ... }, "/")
end

-- 必要ならデフォルトの作成先を固定（例：~/work）
-- 空文字 "" ならカレントディレクトリに作る
local base_dir = "~/Desktop/Projects"  -- 例: vim.fn.expand("~/work")

local function mkdir_p(path)
  -- 再帰的 mkdir （既存ならスキップ）
  local parts = {}
  for part in string.gmatch(path, "[^/]+") do
    table.insert(parts, part)
    local p = table.concat(parts, "/")
    local stat = uv.fs_stat(p)
    if not stat then
      local ok, err = uv.fs_mkdir(p, 493) -- 0755
      if not ok then return false, err end
    elseif stat.type ~= "directory" then
      return false, ("`%s` はディレクトリではありません"):format(p)
    end
  end
  return true
end

local function write_file(path, content)
  local fd, err = uv.fs_open(path, "w", 420) -- 0644
  if not fd then return false, err end
  uv.fs_write(fd, content, -1)
  uv.fs_close(fd)
  return true
end

local function project_exists(path)
  local st = uv.fs_stat(path)
  return st ~= nil
end

local function create_project(name)
  -- 作成先ルートを決定
  -- local root = base_dir
	local root = vim.fn.expand(base_dir)
  local proj_dir = fs_join(root, name)
	print(proj_dir)

  if project_exists(proj_dir) then
    vim.notify(("既に存在します: %s"):format(proj_dir), vim.log.levels.WARN)
    return
  end
--
--   -- ディレクトリ作成
--   local ok, err = mkdir_p(proj_dir);         if not ok then return vim.notify(err, vim.log.levels.ERROR) end
--   ok, err = mkdir_p(fs_join(proj_dir, "input"));  if not ok then return vim.notify(err, vim.log.levels.ERROR) end
--   ok, err = mkdir_p(fs_join(proj_dir, "result")); if not ok then return vim.notify(err, vim.log.levels.ERROR) end
--   ok, err = mkdir_p(fs_join(proj_dir, "script")); if not ok then return vim.notify(err, vim.log.levels.ERROR) end
--
--   -- スクリプト雛形
--   local header = ([[# %s/script/v1.R
-- # 作成: %s
-- # 用途: 最小テンプレート（入力: ./input, 出力: ./result）
-- 		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
--
-- # 依存パッケージの読み込み例
-- # library(readr); library(dplyr)
--
-- # 入力例:
-- # dat <- readr::read_csv("input/data.csv")
--
-- # 処理:
-- # ...
--
-- # 出力例:
-- # readr::write_csv(dat, "result/out.csv")
-- ]]):format(name, os.date("%Y-%m-%d %H:%M:%S"))
--
--   local v1 = fs_join(proj_dir, "script", "v1.R")
--   local v2 = fs_join(proj_dir, "script", "v2.R")
--
--   ok, err = write_file(v1, header); if not ok then return vim.notify(err, vim.log.levels.ERROR) end
--   ok, err = write_file(v2, "# v2.R\n"); if not ok then return vim.notify(err, vim.log.levels.ERROR) end
--
--   vim.notify(("プロジェクト作成: %s"):format(proj_dir), vim.log.levels.INFO)
--
--   -- 生成した v1.R を開く
--   vim.cmd.edit(v1)
end

-- 対話的入力: <leader>pn で実行
vim.keymap.set("n", "<leader>pn", function()
  vim.ui.input({ prompt = "新規プロジェクト名: " }, function(input)
    if not input or input == "" then return end
    create_project(input)
  end)
end, { desc = "新規プロジェクト（テンプレート生成）" })

-- コマンドでも使えるように
vim.api.nvim_create_user_command("ProjectNew", function(opts)
  create_project(opts.args)
end, { nargs = 1, complete = "file" })

