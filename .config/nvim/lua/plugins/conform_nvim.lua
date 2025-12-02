return {
    "stevearc/conform.nvim",

    opts = {
        formatters_by_ft = {
            bash = { "shellharden" },
            c = { "clang-format" },
            cmake = { "cmakelang" },
            cpp = { "clang-format" },
            cs = { "csharpier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            js = { "prettier" },
            latex = { "tex-fmt", "bibtex-tidy" },
            lua = { "stylua" },
            md = { "prettier" },
            nginx = { "nginx-config-formatter" },
            nix = { "nixfmt" },
            python = { "isort", "black" },
            sql = { "sqlfmt" },
            ts = { "prettier" },
            yaml = { "prettier" },
        },

        format_on_save = {
            timeout_ms = 2000,
            lsp_format = "fallback",
        },
    },
}
