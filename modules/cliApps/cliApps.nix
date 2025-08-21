{lib, ...}: let
  # Automatically discover and import all .nix files in this directory
  # This eliminates the need to manually maintain the imports list
  cliAppFiles =
    builtins.filter (name: lib.hasSuffix ".nix" name && name != "cliApps.nix")
    (builtins.attrNames (builtins.readDir ./.));

  # Import each discovered file
  cliAppImports = builtins.map (file: ./. + "/${file}") cliAppFiles;
in {
  # Automatically import all CLI app modules
  imports = cliAppImports;

  # You can add global CLI app configurations here if needed
  config = {
    # Example: Global CLI app settings that apply to all enabled apps
    # home.sessionVariables = lib.mkIf (config.ghostty.enable || config.btop.enable) {
    #   EDITOR = "nvim";
    # };
  };
}
