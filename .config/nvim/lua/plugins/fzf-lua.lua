return {
	"ibhagwan/fzf-lua",
	dependencies = { "echasnovski/mini.icons" },

	opts = function()
		local fzf = require("fzf-lua")
		local actions = fzf.actions

		return {
			files = {
				actions = {
					["alt-i"] = { actions.toggle_ignore },
					["alt-h"] = { actions.toggle_hidden },
				},
			},

			grep = {
				actions = {
					["alt-i"] = { actions.toggle_ignore },
					["alt-h"] = { actions.toggle_hidden },
				},
			},
		}
	end,

	keys = {
		{
			"<leader>ff",
			function()
				require("fzf-lua").builtin()
			end,
			desc = "Available [F]uzzy [F]inders.",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").resume()
			end,
			desc = "[F]uzzy [R]esume.",
		},
		{
			"<leader>fo",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "[F]uzzy [O]ld.",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "[F]ind [K]eymaps.",
		},
		{
			"<leader><leader>",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "[ , ] Existing Buffers.",
		},
		{
			"<leader>fcw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "[F]uzzy [C]urrent [W]ord.",
		},
		{
			"<leader>fcW",
			function()
				require("fzf-lua").grep_cWORD()
			end,
			desc = "[F]uzzy [C]urrent [W]ORD.",
		},
		{
			"<leader>ft",
			function()
				require("fzf-lua").files()
			end,
			desc = "[F]uzzy [T]ree in CWD.",
		},
		{
			"<leader>/",
			function()
				require("fzf-lua").lgrep_curbuf()
			end,
			desc = "[F]uzzy [S]earch in buffer.",
		},
		{
			"<leader>fs",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "[F]uzzy [S]earch in CWD.",
		},
		{
			"<leader>fat",
			function()
				require("fzf-lua").files({ cwd = "~/appstract" })
			end,
			desc = "[F]uzzy [A]ppstract [T]ree.",
		},
		{
			"<leader>fas",
			function()
				require("fzf-lua").live_grep({ cwd = "~/appstract" })
			end,
			desc = "[F]uzzy [A]ppstract [S]earch.",
		},
	},
}
