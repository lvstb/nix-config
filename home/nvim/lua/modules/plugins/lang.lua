local lang = {}

lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
-- lang["chrisbra/csv.vim"] = {
-- 	lazy = true,
-- 	ft = "csv",
-- }
lang["phelipetls/jsonpath.nvim"] = {
	lazy = true,
	ft = "json",
}
-- lang["ray-x/go.nvim"] = {
-- 	lazy = true,
-- 	event = { "CmdlineEnter" },
-- 	ft = { "go", "gomod", "gosum" },
-- 	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
-- 	config = require("lang.go"),
-- 	dependencies = { "ray-x/guihua.lua" },
-- }
-- lang["pmizio/typescript-tools.nvim"] = {
-- 	event = "BufReadPre",
-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
-- 	config = require("lang.typescript-tools"),
-- }
return lang
