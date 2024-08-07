local wk = require("which-key")

wk.setup({})

wk.register({
	K = { "Definition Hover" },
	["<C-k>"] = { "Signature Help" },
	["<leader>"] = {
		a = { "Aerial" },
		t = { "NeoTree" },
		q = {
			name = "Diagnostics",
			q = { "Toggle Diagnostic List" },
			t = { "Toggle Inline Diagnostics" },
			n = { "Next Diagnostic" },
			N = { "Previous Diagnostic" },
			e = { "Open Diagnostic Float" },
		},
		d = {
			name = "Debug",
			b = { "Toggle Breakpoint" },
			u = { "Toggle UI" },
			c = { "Continue" },
			t = { "Run Test" },
		},
		g = {
			name = "DiffView",
			o = { "<cmd>DiffviewOpen<cr>", "Open Diff - Current" },
			O = { "<cmd>DiffviewOpen origin/main...HEAD<cr>", "Open Diff - Main" },
			h = { "<cmd>DiffviewFileHistory<cr>", "Diff History" },
			H = {
				"<cmd>DiffviewFileHistory --range=origin..HEAD<cr>",
				"Diff History - Main",
			},
			c = { "<cmd>DiffviewClose<cr>", "Close Diff" },
			b = { "Git Blame Line" },
			B = { "Git Blame Full" },
		},
		f = {
			name = "Find - Telescope",
			f = { "<cmd>Telescope find_files<cr>", "Find File" },
			g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
			b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
			j = { "<cmd>Telescope jumplist<cr>", "Jump List" },
			h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
		},
		l = {
			name = "LSP",
			D = { "Declaration" },
			d = { "Definition" },
			f = { "Format" },
			i = { "Implementation" },
			n = { "Rename" },
			r = { "References" },
			t = { "Type Definition" },
		},
		s = {
			name = "Screenshot",
			mode = { "v", "n" },
			b = { "Buffer Screenshot", mode = { "v", "n" } },
			s = { "Selected Screenshot", mode = "v" },
			v = { "Visual Screenshot", mode = "n" },
		},
	},
})
