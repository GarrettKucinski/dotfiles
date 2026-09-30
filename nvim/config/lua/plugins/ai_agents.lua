return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = { terminal_cmd = "env -u ANTHROPIC_API_KEY claude" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>aC", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add file to Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude Code" },
    },
  },
  {
    "nwiizo/codex.nvim",
    event = "VeryLazy",
    cmd = {
      "Codex",
      "CodexFocus",
      "CodexAsk",
      "CodexAdd",
      "CodexSendVisual",
      "CodexAddVisual",
      "CodexTreeAdd",
      "CodexStatus",
      "CodexStop",
    },
    opts = { cwd = "nvim" },
    keys = {
      { "<leader>ax", "<cmd>CodexFocus<cr>", desc = "Focus or hide Codex" },
      { "<leader>aX", "<cmd>CodexAdd<cr>", desc = "Add file to Codex" },
      { "<leader>aa", "<cmd>CodexAsk<cr>", desc = "Ask Codex with file context" },
      { "<leader>aS", ":<C-U>CodexSendVisual<CR>", mode = "v", desc = "Send selection to Codex" },
    },
  },
}
