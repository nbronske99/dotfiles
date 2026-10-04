-- Claude Code inside nvim, speaking the same IDE protocol as the VS Code
-- extension: it sees the current file/selection and project .claude/ config.
return {
    "coder/claudecode.nvim",
    opts = {
        terminal = { split_side = "right", split_width_percentage = 0.38 },
    },
    keys = {
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add file to Claude" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude session" },
    },
}
