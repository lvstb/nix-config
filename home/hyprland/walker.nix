{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Official walker home-manager module
  programs.walker = {
    enable = true;
    runAsService = true;

    # Stylix-integrated theme
    config.theme = "stylix";
    themes."stylix" = {
      style = ''
      /* Define color variables using stylix colors */
      @define-color base #${config.lib.stylix.colors.base00}; /* main background */
      @define-color mantle #${config.lib.stylix.colors.base01}; /* darker background */  
      @define-color surface0 #${config.lib.stylix.colors.base02}; /* popup background */
      @define-color surface1 #${config.lib.stylix.colors.base03}; /* comments/disabled */
      @define-color surface2 #${config.lib.stylix.colors.base04}; /* dark foreground */
      @define-color text #${config.lib.stylix.colors.base05}; /* main foreground */
      @define-color subtext1 #${config.lib.stylix.colors.base06}; /* light foreground */
      @define-color subtext0 #${config.lib.stylix.colors.base07}; /* lightest foreground */
      @define-color red #${config.lib.stylix.colors.base08}; /* variables/errors */
      @define-color peach #${config.lib.stylix.colors.base09}; /* integers/booleans */
      @define-color yellow #${config.lib.stylix.colors.base0A}; /* classes/search */
      @define-color green #${config.lib.stylix.colors.base0B}; /* strings/success */
      @define-color teal #${config.lib.stylix.colors.base0C}; /* support/regex */
      @define-color blue #${config.lib.stylix.colors.base0D}; /* functions/info */
      @define-color mauve #${config.lib.stylix.colors.base0E}; /* keywords/storage */
      @define-color flamingo #${config.lib.stylix.colors.base0F}; /* deprecated/tags */
      
      /* Semantic color aliases */
      @define-color selected-text @blue;
      @define-color border @surface1;
      @define-color foreground @text;
      @define-color background @base;

      /* Use original omarchy CSS structure */
      /* Reset all elements */
      #window,
      #box,
      #search,
      #password,
      #input,
      #prompt,
      #clear,
      #typeahead,
      #list,
      child,
      scrollbar,
      slider,
      #item,
      #text,
      #label,
      #sub,
      #activationlabel {
        all: unset;
      }

      * {
        font-family: ${config.stylix.fonts.monospace.name};
        font-size: ${toString config.stylix.fonts.sizes.applications}px;
      }

      /* Window */
      #window {
        background: transparent;
        color: @text;
      }

      /* Main box container */
      #box {
        background: alpha(@base, 0.95);
        padding: 20px;
        border: 2px solid @border;
        border-radius: 0px;
      }

      /* Search container */
      #search {
        background: @surface0;
        padding: 10px;
        margin-bottom: 0;
        border-bottom: 1px solid @surface1;
      }

      /* Hide prompt icon */
      #prompt {
        opacity: 0;
        min-width: 0;
        margin: 0;
      }

      /* Hide clear button */
      #clear {
        opacity: 0;
        min-width: 0;
      }

      /* Input field */
      #input {
        background: none;
        color: @text;
        padding: 0;
      }

      #input placeholder {
        color: @subtext0;
      }

      /* Hide typeahead */
      #typeahead {
        opacity: 0;
      }

      /* List */
      #list {
        background: transparent;
      }

      /* List items */
      child {
        padding: 0px 12px;
        background: transparent;
        border-radius: 0;
      }

      child:selected,
      child:hover {
        background: transparent;
      }

      /* Item layout */
      #item {
        padding: 0;
      }

      #item.active {
        font-style: italic;
      }

      /* Icon */
      #icon {
        margin-right: 10px;
        -gtk-icon-transform: scale(0.7);
      }

      /* Text */
      #text {
        color: @text;
        padding: 14px 0;
      }

      #label {
        font-weight: normal;
      }

      /* Selected state */
      child:selected #text,
      child:selected #label,
      child:hover #text,
      child:hover #label {
        color: @selected-text;
      }

      /* Hide sub text */
      #sub {
        opacity: 0;
        font-size: 0;
        min-height: 0;
      }

      /* Hide activation label */
      #activationlabel {
        opacity: 0;
        min-width: 0;
      }

      /* Scrollbar styling */
      scrollbar {
        opacity: 0;
      }

      /* Hide spinner */
      #spinner {
        opacity: 0;
      }

      /* Hide AI elements */
      #aiScroll,
      #aiList,
      .aiItem {
        opacity: 0;
        min-height: 0;
      }

      /* Bar entry (switcher) */
      #bar {
        opacity: 0;
        min-height: 0;
      }

      .barentry {
        opacity: 0;
      }
      '';
    };
  };

  # Calculator dependency
  home.packages = with pkgs; [
    libqalculate
  ];
}