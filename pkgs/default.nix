# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # zscaler = import ./zscaler.nix {inherit pkgs;};
  opencode = import ./opencode.nix {
    inherit (pkgs) lib stdenv fetchzip autoPatchelfHook glibc;
  };
  opencode-impure = import ./opencode-impure.nix {
    inherit (pkgs) lib stdenv unzip autoPatchelfHook glibc;
  };
}
