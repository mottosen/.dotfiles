return {
	"stevearc/conform.nvim",

	-- honorable mentions:
	-- ast-grep

	opts = {
		formatters_by_ft = {
			bash = { "shellcheck", "beautysh" },
			cs = { "sonarlint-language-server", "csharpier" },
			c = { "sonarlint-language-server", "clang-format" },
			cmake = { "cmakelang" },
			docker = { "sonarlint-language-server" },
			fs = { "fantomas" },
			haskell = { "hlint", "fourmolu" },
			json = { "biome", "prettierd", "prettier", stop_after_first = true },
			kubernetes = { "sonarlint-language-server" },
			ts = { "biome", "prettierd", "prettier", stop_after_first = true },
			lua = { "stylua" },
			latex = { "tex-fmt", "bibtex-tidy" },
			makefile = { "checkmake" },
			markdown = { "markdownlint", "prettierd", "prettier", stop_after_first = true },
			nix = { "nixfmt" },
			python = { "sonarlint-language-server", "isort", "black" },
			sql = { "sqlfluff", "sqlfmt" },
			terraform = { "sonarlint-language-server", "terraform" },
			yaml = { "sonarlint-language-server", "prettierd", "prettier", stop_after_first = true },
			nginx = { "nginx-config-formatter" },
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
