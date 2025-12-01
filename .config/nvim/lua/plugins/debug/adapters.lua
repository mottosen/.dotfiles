local M = {}

-- Ensure installed
M.ensure_installed = {
    "cpptools",
}

-- Adapter for C++ debugging
M.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
}

return M
