vim.o.clipboard = "unnamedplus"
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.mouse = "a"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Hyprlang LSP
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
	pattern = {"*.hl", "hypr*.conf"},
	callback = function(event)
		-- print(string.format("starting hyprls for %s", vim.inspect(event)))
		vim.lsp.start {
			name = "hyprlang",
			cmd = {"hyprls"},
			root_dir = vim.fn.getcwd(),
		}
	end
})
