local M = {}

M.keys = {
    {
        "<leader>dB",
        function()
            require("dap").set_breakpoint(
                vim.fn.input("Breakpoint condition: ")
            )
        end,
        desc = "Breakpoint Condition",
    },

    {
        "<leader>db",
        function()
            require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
    },

    {
        "<leader>dc",
        function()
            require("dap").continue()
        end,
        desc = "Run/Continue",
    },

    {
        "<leader>da",
        function()
            require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
    },

    {
        "<leader>dC",
        function()
            require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
    },

    {
        "<leader>dg",
        function()
            require("dap").goto_()
        end,
        desc = "Go to Line (No Execute)",
    },

    {
        "<leader>di",
        function()
            require("dap").step_into()
        end,
        desc = "Step Into",
    },

    {
        "<leader>dj",
        function()
            require("dap").down()
        end,
        desc = "Down",
    },

    {
        "<leader>dk",
        function()
            require("dap").up()
        end,
        desc = "Up",
    },

    {
        "<leader>dl",
        function()
            require("dap").run_last()
        end,
        desc = "Run Last",
    },

    {
        "<leader>do",
        function()
            require("dap").step_out()
        end,
        desc = "Step Out",
    },

    {
        "<leader>dO",
        function()
            require("dap").step_over()
        end,
        desc = "Step Over",
    },

    {
        "<leader>dP",
        function()
            require("dap").pause()
        end,
        desc = "Pause",
    },

    {
        "<leader>dr",
        function()
            require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
    },

    {
        "<leader>ds",
        function()
            require("dap").session()
        end,
        desc = "Session",
    },

    {
        "<leader>dt",
        function()
            require("dap").terminate()
        end,
        desc = "Terminate",
    },

    {
        "<leader>dw",
        function()
            require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
    },
}

M.disasm_keys = {
    {
        "<leader>dD",
        function()
            if require("dap").session() then
                vim.cmd("vertical DapDisasm")
            else
                vim.notify("No active debug session", vim.log.levels.WARN)
            end
        end,
        desc = "Disassembly View",
    },
    {
        "<leader>dIi",
        function()
            if require("dap").session() then
                require("dap").step_into({ granularity = "instruction" })
            end
        end,
        desc = "Step Into (Instruction)",
    },
    {
        "<leader>dIo",
        function()
            if require("dap").session() then
                require("dap").step_over({ granularity = "instruction" })
            end
        end,
        desc = "Step Over (Instruction)",
    },
    {
        "<leader>dIb",
        function()
            if require("dap").session() then
                require("dap").step_back({ granularity = "instruction" })
            end
        end,
        desc = "Step Back (Instruction)",
    },
}

M.dapui_keys = {
    {
        "<leader>du",
        function()
            require("dapui").toggle({})
        end,
        desc = "Dap UI",
    },
    {
        "<leader>de",
        function()
            require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
    },
}

return M
