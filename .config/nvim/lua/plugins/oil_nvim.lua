return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    opts = {
        view_options = {
            show_hidden = true,
        },
        float = {
            border = "rounded",
            padding = 2,
            max_width = 90,
            max_height = 30,
        },
        confirmation = {
            border = "rounded",
            padding = 2,
            max_width = 90,
            max_height = 30,
        },
    },
}
