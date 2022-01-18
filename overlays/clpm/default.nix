self: super:

{

  clpm = super.clpm.overrideAttrs (oldAttrs: rec {
    pname = "clpm";
    version = "0.4.2";

    src = super.fetchgit {
      url = "https://gitlab.common-lisp.net/clpm/clpm";
      rev = "e6b571dd5460978a3cbb81468975b7ba7469a121";
      fetchSubmodules = true;
      sha256 = "sha256-yLVwyqDlm10aiUWq9FsLuv1X7ydPzZiU9hQE+trrlhg=";
    };

    installPhase = ''
      runHook preInstall

      cd build/release-staging/dynamic/clpm-${version}*/
      INSTALL_ROOT=$out/ bash install.sh

      runHook postInstall
    '';


  });

}
