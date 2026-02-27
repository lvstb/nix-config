{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # GTK icon theme — fixes missing app icons in walker (and all GTK apps on Hyprland)
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  # Official walker home-manager module
  programs.walker = {
    enable = true;
    runAsService = true;

    config.theme = "stylix";
    config.providers.default = ["desktopapplications" "calc" "websearch"];
    config.providers.empty = ["desktopapplications"];
    config.providers.prefixes = [
      { prefix = "!";    provider = "runner"; }
      { prefix = "~";    provider = "files"; }
      { prefix = "?";    provider = "websearch"; }
      { prefix = "clip "; provider = "clipboard"; }
      { prefix = "win ";  provider = "windows"; }
      { prefix = "key ";  provider = "menus:hyprland-keybinds"; }
    ];

    themes."stylix" = {

      style = ''
        /* ── Color palette (Stylix/Gruvbox-dark) ─────────────────────── */
        @define-color base     #${config.lib.stylix.colors.base00};
        @define-color mantle   #${config.lib.stylix.colors.base01};
        @define-color surface0 #${config.lib.stylix.colors.base02};
        @define-color surface1 #${config.lib.stylix.colors.base03};
        @define-color surface2 #${config.lib.stylix.colors.base04};
        @define-color text     #${config.lib.stylix.colors.base05};
        @define-color subtext1 #${config.lib.stylix.colors.base06};
        @define-color subtext0 #${config.lib.stylix.colors.base07};
        @define-color blue     #${config.lib.stylix.colors.base0D};
        @define-color mauve    #${config.lib.stylix.colors.base0E};

        /* ── Reset ──────────────────────────────────────────────────── */
        * {
          all: unset;
          font-family: ${config.stylix.fonts.sansSerif.name};
          font-size: ${toString config.stylix.fonts.sizes.applications}pt;
        }

        /* ── Window — transparent background ───────────────────────── */
        window {
          background: transparent;
        }

        /* ── Main card — Raycast-style floating panel ───────────────── */
        .box-wrapper {
          background: alpha(@base, 0.97);
          border: 1px solid alpha(@surface1, 0.7);
          border-radius: 14px;
          box-shadow:
            0 40px 80px rgba(0,0,0,0.6),
            0 12px 32px rgba(0,0,0,0.4),
            inset 0 1px 0 alpha(@subtext0, 0.05);
        }

        /* ── Search bar ─────────────────────────────────────────────── */
        .search-container {
          border-bottom: 1px solid alpha(@surface1, 0.5);
        }

        .input {
          background: transparent;
          color: @text;
          font-size: 17pt;
          font-weight: 400;
          padding: 18px 20px;
          caret-color: @blue;
        }

        .input placeholder {
          color: alpha(@subtext0, 0.5);
        }

        .input selection {
          background: alpha(@blue, 0.25);
        }

        /* ── Results list ───────────────────────────────────────────── */
        .list {
          color: @text;
          padding: 6px 0;
        }

        /* Each row */
        child {
        }

        /* ── Item layout ────────────────────────────────────────────── */
        .item-box {
          padding: 8px 14px;
          border-radius: 8px;
          margin: 1px 8px;
        }

        child:selected .item-box {
          background: alpha(@surface0, 0.8);
        }

        /* App icon — large, well-spaced */
        .item-image {
          -gtk-icon-size: 34px;
          margin-right: 14px;
          border-radius: 6px;
        }

        .item-image-text {
          font-size: 26px;
          margin-right: 14px;
        }

        /* Primary label */
        .item-text {
          color: @text;
          font-weight: 500;
        }

        child:selected .item-text {
          color: @blue;
        }

        /* Sub-label — visible description like Raycast */
        .item-subtext {
          color: alpha(@subtext0, 0.65);
          font-size: ${toString (config.stylix.fonts.sizes.applications - 1)}pt;
          margin-top: 1px;
        }

        child:selected .item-subtext {
          color: alpha(@subtext1, 0.8);
        }

        /* Quick-activation numbers */
        .item-quick-activation {
          color: alpha(@subtext0, 0.5);
          font-size: 9pt;
          padding: 3px 6px;
          border-radius: 4px;
          border: 1px solid alpha(@surface1, 0.5);
          margin-left: 8px;
        }

        child:selected .item-quick-activation {
          color: @blue;
          border-color: alpha(@blue, 0.4);
        }

        /* ── Placeholder / empty state ──────────────────────────────── */
        .placeholder,
        .elephant-hint {
          color: alpha(@subtext0, 0.4);
          font-size: 13pt;
          padding: 24px;
        }

        /* ── Keybinds bar — hidden ──────────────────────────────────── */
        .keybinds {
          opacity: 0;
          min-height: 0;
        }

        /* ── Scrollbar ──────────────────────────────────────────────── */
        scrollbar {
          opacity: 0;
        }

        /* ── Error ──────────────────────────────────────────────────── */
        .error {
          padding: 10px 20px;
          color: @text;
          background: alpha(@base, 0.5);
          font-size: 10pt;
        }

        /* ── Italic for currently-running apps ──────────────────────── */
        :not(.calc).current {
          font-style: italic;
        }
      '';
    };
  };

  # Hyprland keybindings menu — dynamically reads from hyprctl binds
  # Uses Lua 5.1 compatible syntax (gopher-lua)
  xdg.configFile."elephant/menus/hyprland-keybinds.lua".text = ''
    Name = "hyprland-keybinds"
    NamePretty = "Keybindings"
    Icon = "input-keyboard"
    Description = "Hyprland keybindings"
    Action = "wl-copy %VALUE%"

    -- Lua 5.1 bitwise AND via modulo arithmetic
    local function band(a, b)
      local result = 0
      local bit = 1
      while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then result = result + bit end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
      end
      return result
    end

    function GetEntries()
      local entries = {}

      local handle = io.popen("hyprctl binds -j 2>/dev/null")
      if not handle then return entries end

      local raw = handle:read("*a")
      handle:close()

      for obj in raw:gmatch("{(.-)}\n?%s*[,\n%]]") do
        local modmask = tonumber(obj:match('"modmask":%s*(%d+)'))
        local key     = obj:match('"key":%s*"([^"]*)"')
        local disp    = obj:match('"dispatcher":%s*"([^"]*)"')
        local arg     = obj:match('"arg":%s*"([^"]*)"')
        local desc    = obj:match('"description":%s*"([^"]*)"')
        local mouse   = obj:match('"mouse":%s*true')
        local submap  = obj:match('"submap":%s*"([^"]*)"')

        if not mouse and key and key ~= "" then
          local mods = {}
          if modmask then
            if band(modmask, 64)   > 0 then table.insert(mods, "Super") end
            if band(modmask, 1)    > 0 then table.insert(mods, "Shift") end
            if band(modmask, 4)    > 0 then table.insert(mods, "Alt")   end
            if band(modmask, 4096) > 0 then table.insert(mods, "AltGr") end
          end

          local combo = table.concat(mods, "+")
          if #mods > 0 then combo = combo .. "+" end
          combo = combo .. key

          local subtext
          if desc and desc ~= "" then
            subtext = desc
          elseif arg and arg ~= "" then
            subtext = (disp or "") .. "  " .. arg
          else
            subtext = disp or ""
          end

          local text = combo
          if submap and submap ~= "" then
            text = "[" .. submap .. "]  " .. combo
          end

          subtext = subtext:gsub("uwsm app %-%- ", "")

          table.insert(entries, {
            Text    = text,
            Subtext = subtext,
            Value   = combo,
            Icon    = "input-keyboard-symbolic",
          })
        end
      end

      return entries
    end
  '';

  # Calculator dependency
  home.packages = with pkgs; [
    libqalculate
  ];
}
