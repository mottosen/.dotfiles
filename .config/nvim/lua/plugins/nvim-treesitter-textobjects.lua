return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = {
                        query = "@class.inner",
                        desc = "Select inner part of a class region",
                    },
                    ["as"] = {
                        query = "@local.scope",
                        query_group = "locals",
                        desc = "Select language scope",
                    },
                },
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V", -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
                include_surrounding_whitespace = true,
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = {
                        query = "@parameter.inner",
                        desc = "Swap with next parameter.",
                    },
                },
                swap_previous = {
                    ["<leader>A"] = {
                        query = "@parameter.inner",
                        desc = "Swap with previous parameter.",
                    },
                },
            },
        })
    end,
}
