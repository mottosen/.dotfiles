-- When gdb v14 is available, see https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-gdb
return {
	{
		"mfussenegger/nvim-dap",

		dependencies = {
			"rcarriga/nvim-dap-ui",
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

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

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
		"rcarriga/nvim-dap-ui",

		dependencies = { "nvim-neotest/nvim-nio" },

		keys = {
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
		},

		opts = {},

		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end

			-- dap.listeners.before.event_terminated["dapui_config"] = function()
			-- 	dapui.close({})
			-- end

			-- dap.listeners.before.event_exited["dapui_config"] = function()
			-- 	dapui.close({})
			-- end
		end,
	},
}
