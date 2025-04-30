local M = {}

M.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = vim.fn.getcwd(),
		stopOnEntry = false,
		args = {},
		runInTerminal = true,
	},
}

return M
