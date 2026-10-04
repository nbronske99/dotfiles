-- Native LSP (nvim 0.11+). Server configs here; plugin layers (e.g. ml-env)
-- can add their own servers without clobbering these.

local capabilities = nil
local ok, blink = pcall(require, "blink.cmp")
if ok then capabilities = blink.get_lsp_capabilities() end

-- clangd reads compile_flags.txt / compile_commands.json for flags and
-- .clang-tidy / .clang-format for lint + style, so the editor and the
-- command-line build always agree.
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--header-insertion=never",
        "--completion-style=detailed",
        "--background-index",
    },
    filetypes = { "c", "cpp" },
    root_markers = { "compile_flags.txt", "compile_commands.json", ".clang-tidy", ".git" },
    capabilities = capabilities,
})

if vim.fn.executable("clangd") == 1 then
    vim.lsp.enable("clangd")
end

vim.diagnostic.config({
    virtual_text = { spacing = 2, source = "if_many" },
    severity_sort = true,
    float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("dotfiles_lsp_attach", { clear = true }),
    callback = function(event)
        local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gr", vim.lsp.buf.references, "Find references")
        map("K", vim.lsp.buf.hover, "Show documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cf", function() vim.lsp.buf.format({ async = false }) end, "Format buffer")
        map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
        -- ]d / [d (next/prev diagnostic) are nvim defaults
    end,
})

-- Format C/C++ on save, but only inside projects that ship a .clang-format,
-- so random C++ files elsewhere keep their own style.
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("dotfiles_cpp_format", { clear = true }),
    pattern = { "*.c", "*.cpp", "*.cc", "*.h", "*.hpp" },
    callback = function(args)
        if vim.fs.find(".clang-format", { upward = true, path = vim.fs.dirname(args.file) })[1] then
            vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 1000, name = "clangd" })
        end
    end,
})
