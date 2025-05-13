return function()
	require("mason").setup({
		ui = {
			border = "rounded",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	require("lspconfig.ui.windows").default_options.border = "single"
	require("neodev").setup()

	-- Now use the updated mason-lspconfig setup
	require("modules.configs.completion.mason-lspconfig").setup()

	vim.diagnostic.config({
		title = false,
		underline = true,
		virtual_text = true,
		signs = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			source = "always",
			style = "minimal",
			border = "rounded",
			header = "",
			prefix = "",
		},
	})

	local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end
