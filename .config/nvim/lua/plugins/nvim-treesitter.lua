return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "c_sharp", "css", "csv", "bash", "cmake", "dockerfile", "fsharp", "git_config", "git_rebase", "gitcommit", "gitignore", "haskell", "make", "nginx", "python"
            },

            auto_install = false,
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },

            require'nvim-treesitter.configs'.setup {
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Enter>",
                        node_incremental = "<Enter>",
                        scope_incremental = false,
                        node_decremental = "<Backspace>",
                    },
                },
            },
        })
    end
}

