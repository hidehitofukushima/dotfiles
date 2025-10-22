local fzf = require("fzf-lua")
local actions = require("fzf-lua").actions

local M = {}

local function first(sel)
	return type(sel) == "table" and sel[1] or sel
end

M.project_files = function()
	-- 検索対象ディレクトリ（存在する方のみを使う）
	local search_dirs = {
		"~/Desktop/Projects/",
		"~/Desktop/Projects_Other/",
		"~/Desktop/Projects_wgs_d/",
		"~/Desktop/Projects_wgs_dd/",
		"~/Desktop/Projects_wgs_ddd/",
		"~/Desktop/Office/",
	}
	-- findコマンドを動的生成（realpathで絶対パス化）
	-- local find_cmd = "find " .. table.concat(search_dirs, " ") .. " -type f -exec realpath {} + 2>/dev/null"
	local find_cmd = "find " ..
  table.concat(search_dirs, " ") ..
  " -type f " ..
  "-not -path '*/.*' " ..
  "-exec realpath {} + 2>/dev/null"


	fzf.files({
		prompt = "PROJ> ",
		cwd = "/", -- 相対化されないように固定
		cmd = find_cmd,
		file_icons = false,
		git_icons = false,
		path_display = function(_, x) return x end, -- 絶対パスそのまま表示
		winopts = {
			width = 0.95,                             -- fzf全体の幅（画面の95%）
			height = 0.90,                            -- fzf全体の高さ（画面の90%）
			preview = {
				layout = "vertical",                    -- "horizontal" だと左右分割, "vertical" は上下
				vertical = "down:70%",                  -- 上下分割の場合、プレビューが下70%
				horizontal = "right:60%",               -- 左右分割なら右60%にプレビュー
				scrollbar = "float",                    -- プレビュー内スクロールバー表示
				hidden = false,                         -- 常に表示（必要ならtrueでデフォ非表示）
			},
		},
		actions = {
			-- Enter: Neovimで開く
			["default"] = actions.file_edit,

			-- Ctrl-y: 絶対パスをヤンク
			["ctrl-y"] = function(selected)
				local path = vim.fn.trim(first(selected))
				vim.fn.setreg("+", path)
				vim.fn.setreg('"', path)
				vim.notify("📋 Copied: " .. path)
			end,

			-- Ctrl-o: macOSデフォルトアプリで開く
			["ctrl-o"] = function(selected)
				local path = vim.fn.trim(first(selected))
				vim.fn.jobstart({ "open", path }, { detach = true })
				vim.notify("🚀 Opened: " .. path)
			end,

			-- Ctrl-r: Finderで表示
			["ctrl-r"] = function(selected)
				local path = vim.fn.trim(first(selected))
				vim.fn.jobstart({ "open", "-R", path }, { detach = true })
				vim.notify("📂 Finderで表示: " .. path)
			end,
		},
	})
end

return M
