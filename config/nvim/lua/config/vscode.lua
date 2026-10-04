-- vscode-neovim backend: the same leader keys as terminal nvim, mapped to
-- VS Code commands. gd / gr / K / ]d work natively through vscode-neovim.

local vscode = require("vscode")

local function action(name, args)
    return function() vscode.action(name, args and { args = args } or nil) end
end

local function task(label)
    return action("workbench.action.tasks.runTask", { label })
end

local map = vim.keymap.set

-- Find (telescope equivalents)
map("n", "<leader>ff", action("workbench.action.quickOpen"), { desc = "Find files" })
map("n", "<leader>fg", action("workbench.action.findInFiles"), { desc = "Grep project" })
map("n", "<leader>fb", action("workbench.action.showAllEditors"), { desc = "List buffers" })

-- LSP (clangd extension)
map("n", "<leader>rn", action("editor.action.rename"), { desc = "Rename symbol" })
map("n", "<leader>ca", action("editor.action.quickFix"), { desc = "Code action" })
map("n", "<leader>cf", action("editor.action.formatDocument"), { desc = "Format buffer" })
map("n", "<leader>e", action("editor.action.showHover"), { desc = "Line diagnostics" })
map("n", "]d", action("editor.action.marker.next"), { desc = "Next diagnostic" })
map("n", "[d", action("editor.action.marker.prev"), { desc = "Prev diagnostic" })

-- Build / run / test / lint (tasks defined in the course repo's .vscode/tasks.json)
map("n", "<leader>mb", action("workbench.action.tasks.build"), { desc = "Build current file" })
map("n", "<leader>mr", task("cs: run"), { desc = "Build + run current file" })
map("n", "<leader>mt", task("cs: test"), { desc = "Run golden I/O tests" })
map("n", "<leader>ml", task("cs: lint"), { desc = "Lint current file" })

-- Claude Code extension (same keys as claudecode.nvim)
map("n", "<leader>ac", action("claude-vscode.sidebar.open"), { desc = "Open Claude" })
map("n", "<leader>af", action("claude-vscode.focus"), { desc = "Focus Claude" })
map("n", "<leader>ab", action("claude-vscode.insertAtMention"), { desc = "Add file to Claude" })
map("x", "<leader>as", action("claude-vscode.insertAtMention"), { desc = "Send selection to Claude" })

-- Pane navigation, matching vim-tmux-navigator in the terminal setup
map("n", "<C-h>", action("workbench.action.navigateLeft"))
map("n", "<C-j>", action("workbench.action.navigateDown"))
map("n", "<C-k>", action("workbench.action.navigateUp"))
map("n", "<C-l>", action("workbench.action.navigateRight"))
