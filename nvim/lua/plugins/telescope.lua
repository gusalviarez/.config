local M = {
		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
				{ "<C-f>", "<cmd>lua require('telescope.builtin').find_files()<cr>" },
				{ "<C-g>", "<cmd>lua require('telescope.builtin').live_grep()<cr>" },
		},
}

return M
