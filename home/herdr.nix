# Herdr configuration - mirrors tmux keybindings and theme from home/terminal.nix
{pkgs, ...}: {
  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [terminal]
    default_shell = "${pkgs.fish}/bin/fish"

    [keys]
    # Same leader/prefix as tmux (C-a)
    prefix = "ctrl+a"

    # Splits: | for side-by-side, - for stacked (same as tmux, opens in cwd)
    split_vertical = "prefix+backslash"
    split_horizontal = "prefix+minus"

    # Pane navigation with hjkl (same as tmux)
    focus_pane_left = "prefix+h"
    focus_pane_down = "prefix+j"
    focus_pane_up = "prefix+k"
    focus_pane_right = "prefix+l"

    # Swap pane with next/previous (tmux: bind > swap-pane -d / bind < swap-pane -U)
    swap_pane_down = "prefix+>"
    swap_pane_up = "prefix+<"

    # Copy mode on Escape (tmux: bind Escape copy-mode)
    copy_mode = "prefix+escape"

    # Reload config (tmux: bind r source-file)
    reload_config = "prefix+r"

    # Open pane scrollback in editor (tmux: bind-key e ... nvim)
    edit_scrollback = "prefix+e"

    [ui]
    # Tab bar on top like tmux status-position top
    tab_bar_position = "top"
    pane_borders = true
    agent_panel_sort = "priority"

    [theme]
    # Follow the terminal's ANSI palette, then match the tmux status bar:
    # black background, white text, blue for the active window
    name = "terminal"

    [theme.custom]
    panel_bg = "black"
    surface0 = "black"
    surface1 = "brightblack"
    text = "white"
    accent = "blue"
    blue = "blue"
  '';
}
