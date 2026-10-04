-- Debugger. Prefers the cpptools adapter (OpenDebugAD7) that the VS Code C/C++
-- extension ships, so both editors drive gdb through the same engine and
-- interactive cin works via runInTerminal. Falls back to gdb's native DAP
-- (gdb >= 14), which can't take keyboard input but can read stdin from a file.
-- Keys match VS Code: F5 continue, F9 breakpoint, F10 over, F11 into, S-F11 out.

local function cpptools_adapter()
    local hits = vim.fn.glob(vim.fn.expand("~/.vscode/extensions/ms-vscode.cpptools-*/debugAdapters/bin/OpenDebugAD7"), false, true)
    return hits[#hits]
end

-- Build the current file with `cs build` and return the binary path
local function build_current()
    local file = vim.fn.expand("%:p")
    if vim.fn.executable("cs") == 1 then
        local out = vim.fn.system({ "cs", "build", file })
        if vim.v.shell_error ~= 0 then
            vim.notify(out, vim.log.levels.ERROR)
            return nil
        end
    end
    return vim.fn.expand("%:p:h") .. "/build/" .. vim.fn.expand("%:t:r")
end

local function first_test_input()
    local hits = vim.fn.glob(vim.fn.expand("%:p:h") .. "/tests/*.in", false, true)
    return hits[1]
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end

            -- LeakSanitizer can't run under ptrace; the rest of ASan/UBSan still works
            local asan_env = { ASAN_OPTIONS = "detect_leaks=0" }
            local configs = {}

            local ad7 = cpptools_adapter()
            if ad7 then
                dap.adapters.cppdbg = { id = "cppdbg", type = "executable", command = ad7 }
                local base = {
                    type = "cppdbg",
                    request = "launch",
                    cwd = "${fileDirname}",
                    MIMode = "gdb",
                    miDebuggerPath = vim.fn.exepath("gdb"),
                    stopAtEntry = false,
                    environment = { { name = "ASAN_OPTIONS", value = "detect_leaks=0" } },
                    setupCommands = {
                        { text = "-enable-pretty-printing", ignoreFailures = true },
                    },
                }
                table.insert(configs, vim.tbl_extend("force", base, {
                    name = "Debug current file (interactive)",
                    program = build_current,
                }))
                table.insert(configs, vim.tbl_extend("force", base, {
                    name = "Debug current file (stdin from tests/*.in)",
                    program = build_current,
                    args = function() return { "<", first_test_input() } end,
                }))
            end

            if vim.fn.executable("gdb") == 1 then
                dap.adapters.gdb = {
                    type = "executable",
                    command = "gdb",
                    args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
                }
                table.insert(configs, {
                    name = "Debug current file (gdb native DAP, no stdin)",
                    type = "gdb",
                    request = "launch",
                    program = build_current,
                    cwd = "${fileDirname}",
                    env = asan_env,
                })
            end

            dap.configurations.cpp = configs
            dap.configurations.c = configs

            local map = vim.keymap.set
            map("n", "<F5>", dap.continue, { desc = "Debug: start/continue" })
            map("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
            map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
            map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
            map("n", "<S-F11>", dap.step_out, { desc = "Debug: step out" })
            map("n", "<S-F5>", dap.terminate, { desc = "Debug: stop" })
            map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
            map("n", "<leader>dc", function()
                dap.set_breakpoint(vim.fn.input("Condition: "))
            end, { desc = "Debug: conditional breakpoint" })
            map("n", "<leader>du", dapui.toggle, { desc = "Debug: toggle UI" })
            map({ "n", "x" }, "<leader>de", dapui.eval, { desc = "Debug: eval expression" })
        end,
    },
}
