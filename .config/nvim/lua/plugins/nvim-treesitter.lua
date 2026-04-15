return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        -- Highlight and indent are Neovim core features in 0.12.
        -- Enable them globally for all filetypes where a parser is available.
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
            callback = function()
                pcall(vim.treesitter.start)
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })

        -- Install parsers not bundled with Neovim.
        -- install() is a no-op for parsers already present.
        require("nvim-treesitter").install({
            "asm",
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "javascript",
            "html",
            "c_sharp",
            "css",
            "csv",
            "bash",
            "cmake",
            "dockerfile",
            "fsharp",
            "git_config",
            "git_rebase",
            "gitcommit",
            "gitignore",
            "haskell",
            "make",
            "nginx",
            "python",
            "json",
            "nix",
            "yaml",
        })
    end,
}
