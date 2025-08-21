{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    nvim.enable = lib.mkEnableOption "Enables Neovim";
  };

  config = lib.mkIf config.nvim.enable {
    programs.neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      extraPackages = with pkgs; [
        doq
        sqlite
        cargo
        clang
        cmake
        gcc
        gnumake
        ninja
        pkg-config
        yarn
      ];
    };
  };
  home.packages = with pkgs; [
    # Development - Language servers (for nvim)
    gopls
    nixd
    yaml-language-server
    lua-language-server
    typescript-language-server
    terraform-ls
    marksman
    luajitPackages.luarocks

    # Development - Formatters and linters (for nvim)
    selene
    black
    prettier
    eslint
    alejandra
    stylua
    isort
    buf
    yamllint
    yamlfmt
    markdownlint-cli
  ];
}
