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
    build = ":call mkdp#util#install()",
    init = function()
        vim.g.mkdp_theme = "dark"
        -- vim.g.mkdp_browser = "firefox"
    end,
}
