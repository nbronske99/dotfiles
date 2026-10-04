-- LSP + completion base. Server setup lives in lua/config/lsp.lua (native
-- vim.lsp.config), so no `config` function here: plugin layers that also
-- list these plugins (e.g. ml-env) merge cleanly instead of overriding.
return {
    { "neovim/nvim-lspconfig" },
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            keymap = { preset = "default" },
            appearance = { nerd_font_variant = "mono" },
            completion = { documentation = { auto_show = true } },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
            signature = { enabled = true },
        },
    },
}
