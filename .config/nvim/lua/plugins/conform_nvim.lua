return {
    "stevearc/conform.nvim",

    opts = {
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            objc = { "clang-format" },
            objcpp = { "clang-format" },
            cuda = { "clang-format" },
            bash = { "shellharden" },
            cmake = { "cmakelang" },
            nix = { "nixfmt" },
            python = { "isort", "black" },
            lua = { "stylua" },

            json = { "prettier" },
            tex = { "tex-fmt", "bibtex-tidy" },
            markdown = { "prettier" },

            nginx = { "nginx-config-formatter" },
            sql = { "sqlfmt" },
            cs = { "csharpier" },

            html = { "prettier" },
            css = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
        },

        formatters = {
            ["clang-format"] = {
                prepend_args = { "--style=file", "--fallback-style=WebKit" },
            },
            prettier = {
                prepend_args = { "--bracket-spacing=false" },
            },
        },

        format_on_save = {
            timeout_ms = 2000,
            lsp_format = "fallback",
        },
    },
}
