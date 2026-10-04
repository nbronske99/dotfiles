-- Build / run / test / lint through the `cs` course CLI when it's on PATH,
-- falling back to a plain g++ build. Mirrors the VS Code tasks in
-- lua/config/vscode.lua so the same keys work in both editors.

local has_cs = vim.fn.executable("cs") == 1

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("dotfiles_cpp_make", { clear = true }),
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.makeprg = has_cs and "cs build %"
            or "g++ -std=c++17 -Wall -Wextra -g % -o %:r"
    end,
})

-- Run a shell command in a bottom terminal split; {file} is the current file
local function term(cmd)
    local file = vim.fn.shellescape(vim.fn.expand("%:p"))
    vim.cmd("write")
    vim.cmd("botright 15split")
    vim.cmd.terminal((cmd:gsub("{file}", file)))
    vim.cmd("startinsert")
end

local map = vim.keymap.set

map("n", "<leader>mb", function()
    vim.cmd("write")
    vim.cmd("silent make!")
    vim.cmd("cwindow")
    if #vim.fn.getqflist() == 0 then vim.notify("build ok") end
end, { desc = "Build current file (quickfix)" })

map("n", "<leader>mr", function()
    term(has_cs and "cs run {file}"
        or "g++ -std=c++17 -Wall -Wextra -g {file} -o /tmp/nvim_run && /tmp/nvim_run")
end, { desc = "Build + run current file" })

map("n", "<leader>mt", function() term("cs test {file}") end, { desc = "Run golden I/O tests" })

map("n", "<leader>ml", function()
    vim.cmd("write")
    vim.cmd("cexpr system('cs lint ' .. shellescape(expand('%:p')))")
    vim.cmd("cwindow")
end, { desc = "Lint current file (quickfix)" })

-- Search the instructor's repo (gitignored, so normal grep skips it)
map("n", "<leader>fu", function()
    local root = vim.fs.root(0, { "cs.conf" })
    if not root then return vim.notify("not inside a course repo", vim.log.levels.WARN) end
    require("telescope.builtin").live_grep({ cwd = root .. "/upstream", prompt_title = "Grep upstream" })
end, { desc = "Grep instructor upstream repo" })

-- Leave a terminal split (e.g. the Claude pane) with Alt-h/j/k/l. Esc and
-- Ctrl keys are left alone because Claude Code and shells use them.
for _, dir in ipairs({ "h", "j", "k", "l" }) do
    map("t", "<M-" .. dir .. ">", [[<C-\><C-n><C-w>]] .. dir, { desc = "Leave terminal: window " .. dir })
end
