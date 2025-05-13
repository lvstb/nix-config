local M = {}

function M.setup()
	local nvim_lsp = require("lspconfig")
	local mason_lspconfig = require("mason-lspconfig")

	-- Setup mason-lspconfig first
	mason_lspconfig.setup({
		ensure_installed = require("core.settings").lsp_deps,
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	local opts = {
		capabilities = capabilities,
		on_attach = require("modules.configs.completion.lsp.on_attach").on_attach,
	}

	-- A handler to setup all servers defined in the `servers` directory
	local function mason_lsp_handler(server_name)
		local ok, server_config = pcall(require, "modules.configs.completion.servers." .. server_name)

		if ok then
			nvim_lsp[server_name].setup(vim.tbl_deep_extend("force", opts, server_config))
		else
			nvim_lsp[server_name].setup(opts)
		end
	end

	-- Use setup_handlers method if available or manually set up servers
	if mason_lspconfig.setup_handlers then
		mason_lspconfig.setup_handlers({ mason_lsp_handler })
	else
		-- Fallback for older versions or missing method
		local servers = mason_lspconfig.get_installed_servers()
		for _, server_name in ipairs(servers) do
			mason_lsp_handler(server_name)
		end
	end
end

return M
