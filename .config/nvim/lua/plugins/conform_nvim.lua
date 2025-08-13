return {
	"stevearc/conform.nvim",

	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			sql = { "sqlfmt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			c = { "cpplint", "clang-format" },
			-- c = { "cmakelint", "cmakelang" },
			-- cs = { "csharpier" },
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
