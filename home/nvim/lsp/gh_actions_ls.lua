return {
	cmd = { "gh-actions-language-server", "--stdio" },
	filetypes = { "yaml.github" },
	root_dir = function(fname)
		-- Find .github directory going up the directory tree
		return vim.fs.dirname(vim.fs.find(".github", {
			path = fname,
			upward = true,
		})[1])
	end,
	single_file_support = true,
	capabilities = {
		workspace = {
			didChangeWorkspaceFolders = {
				dynamicRegistration = true,
			},
		},
	},
}
