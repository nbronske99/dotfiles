require("config.options")
require("config.lazy")

if vim.g.vscode then
    -- Running as the vscode-neovim backend: same leader keys, VS Code commands
    require("config.vscode")
else
    -- Loaded after lazy so these LspAttach maps win over any plugin layer's
    require("config.keymaps")
    require("config.lsp")
end
