return {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
    keys = {
        {
            "<leader>mdp",
            "<cmd>MarkdownPreviewToggle<CR>",
            desc = "[M]ark[d]own [p]review toggle",
            ft = "markdown",
        },
    },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    init = function()
        vim.g.mkdp_theme = "dark"
        -- vim.g.mkdp_browser = "firefox"
    end,
}
