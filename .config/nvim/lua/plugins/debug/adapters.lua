local M = {}

-- Ensure installed
M.ensure_installed = {
    "gdb",
    "cpptools",
}

-- Adapter for GDB debugging
M.gdb = {
    type = "executable",
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

-- Adapter for C++ debugging
M.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
}

return M
