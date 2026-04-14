return {
    {
        "mfussenegger/nvim-dap",

        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = "williamboman/mason.nvim",
                cmd = { "DapInstall", "DapUninstall" },
            },
        },

        keys = require("plugins.debug.keys").keys,

        config = function()
            local dap = require("dap")
            local adapters = require("plugins.debug.adapters")
            local configs = require("plugins.debug.configurations")

            require("mason-nvim-dap").setup({
                automatic_installation = true,
                handlers = {},
                ensure_installed = adapters.ensure_installed,
            })

            vim.api.nvim_set_hl(
                0,
                "DapStoppedLine",
                { default = true, link = "Visual" }
            )

            -- setup all adapters that are defined in debugAdapters.lua
            for name, adapter in pairs(adapters) do
                dap.adapters[name] = adapter
            end

            -- setup all configurations that are defined in debugConfigurations.lua
            for name, configuration in pairs(configs) do
                dap.configurations[name] = configuration
            end

            -- setup dap config by VsCode launch.json file
            local vscode = require("dap.ext.vscode")
            local json = require("plenary.json")
            vscode.json_decode = function(str)
                return vim.json.decode(json.json_strip_comments(str))
            end
        end,
    },
    {
        "Jorenar/nvim-dap-disasm",

        dependencies = { "rcarriga/nvim-dap-ui" },

        keys = require("plugins.debug.keys").disasm_keys,

        config = function()
            require("dap-disasm").setup({
                dapui_register = true,
                dapview_register = true,
                dapview = {
                    keymap = "D",
                    label = "Disassembly [D]",
                    short_label = "󰒓 [D]",
                },
                winbar = {
                    enabled = true,
                    labels = {
                        step_into = "Step Into",
                        step_over = "Step Over",
                        step_back = "Step Back",
                    },
                    order = {
                        "step_into",
                        "step_over",
                        "step_back",
                    },
                },
                sign = "DapStopped",
                ins_before_memref = 16,
                ins_after_memref = 16,
                columns = {
                    "address",
                    "instructionBytes",
                    "instruction",
                },
            })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",

        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },

        keys = require("plugins.debug.keys").dapui_keys,

        opts = {
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.3 },
                        { id = "watches", size = 0.2 },
                        { id = "breakpoints", size = 0.2 },
                        { id = "stacks", size = 0.3 },
                    },
                    size = 40,
                    position = "left",
                },
                {
                    elements = {
                        { id = "repl", size = 0.5 },
                        { id = "disassembly", size = 0.5 },
                    },
                    size = 0.3,
                    position = "bottom",
                },
            },
        },

        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.after.event_stopped["disasm_config"] = function()
                require("dap-disasm").refresh()
            end

            -- dap.listeners.before.event_terminated["dapui_config"] = function()
            --     dapui.close({})
            -- end

            -- dap.listeners.before.event_exited["dapui_config"] = function()
            --     dapui.close({})
            -- end
        end,
    },
}
