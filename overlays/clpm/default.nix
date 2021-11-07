self: super:

{

  clpm = super.clpm.overrideAttrs (oldAttrs: rec {
    pname = "clpm";
    version = "0.5.0";

    src = super.fetchgit {
      url = "https://gitlab.common-lisp.net/clpm/clpm";
      rev = "2d8108524bc3f15f10a41e3d0d717f130a121471";
      fetchSubmodules = true;
      sha256 = "sha256-CmfAXH6tDWPHU5eOShEPNvz0PmavKsiRRkbn8/l+nNA=";
    };

    installPhase = ''
      runHook preInstall

      cd build/release-staging/dynamic/clpm-${version}*/
      INSTALL_ROOT=$out/ bash install.sh

      runHook postInstall
    '';


  });

}
