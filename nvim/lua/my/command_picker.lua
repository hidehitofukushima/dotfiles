local fzf = require("fzf-lua")
local M = {}

-- 🔹 登録したいコマンドの一覧
local commands = {
  { "Python3",  "python3 %" },
  { "Rscript",  "Rscript %" },
  { "Bash",     "bash %" },
  { "Zsh",      "zsh %" },
  { "Qsub",     "qsub %" },
	{ "Qstat",    "qstat" },
}

-- 🔹 FZF-Lua ピッカー本体
M.run_command = function()
  local entries = {}
  for _, cmd in ipairs(commands) do
    table.insert(entries, string.format("%-10s │ %s", cmd[1], cmd[2]))
  end

  fzf.fzf_exec(entries, {
    prompt = "CMD> ",
    fzf_opts = {
      ["--header"] = "Choose a command to run on current file",
      ["--ansi"] = true,
    },
    winopts = {
      width = 0.6,
      height = 0.5,
      preview = {
        layout = "vertical",
        vertical = "up:70%",
        title = "Command Preview",
      },
    },
    actions = {
      -- Enter: コマンド実行
      ["default"] = function(selected)
        local line = selected[1]
        if not line then return end
        local cmd = line:match("│%s*(.*)$")  -- 「│」以降を抽出
        local expanded = vim.fn.expandcmd(cmd)  -- % を展開
        vim.notify("🚀 Running: " .. expanded)
        vim.cmd("!" .. expanded)  -- 実行
      end,
    },
  })
end

return M

