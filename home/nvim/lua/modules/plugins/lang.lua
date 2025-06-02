local lang = {}

lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
lang["phelipetls/jsonpath.nvim"] = {
	lazy = true,
	ft = "json",
}
return lang
