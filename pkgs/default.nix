# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  eid-mw = pkgs.eid-mw.overrideAttrs (old: rec {
    version = "5.1.28";
    src = pkgs.fetchurl {
      url = "https://eid.belgium.be/sites/default/files/software/eid-mw-${version}-v${version}.tar.gz";
      hash = "sha256-+5le3GvZfrM7ejuBMgcGJd0VJnpnA59+CKdkc1dH+VY=";
    };
    postPatch = ''
      sed 's@m4_esyscmd_s(.*,@[${version}],@' -i configure.ac
      substituteInPlace configure.ac \
        --replace-fail 'p11kitcfdir=""' 'p11kitcfdir="'$out/share/p11-kit/modules'"'
    '';
  });

  # zscaler = import ./zscaler.nix {inherit pkgs;};
}
