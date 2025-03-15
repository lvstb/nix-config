return function()
	require("blink.cmp").setup({
		-- use a release tag to download pre-built binaries
		version = "v0.*",
		opts = {
			keymap = { preset = "default" },
			-- https://github.com/roguesherlock/dotfiles/blob/a8efee0dd3a0aee9d00e94f9f2040fba2ae2367b/.config/nvim/init.bak.lua#L854
			sources = {
				providers = {},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
		},
	})
end
