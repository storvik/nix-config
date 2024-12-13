# relevant links:
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/emacs/generic.nix
# https://github.com/nix-community/emacs-overlay/blob/master/overlays/emacs.nix
# https://github.com/d12frosted/homebrew-emacs-plus/tree/master/patches/emacs-30

self: super: rec {

  storvik-emacs-base = super.emacs-git.override {
    withSQLite3 = true;
    withWebP = true;
    withImageMagick = true;
    withTreeSitter = true;
  };

  # https://darrinhenein.com/blog/emacs-icon/
  custom-mac-emacs-icon = ./emacs-icon-1.0-dh.icns;

  storvik-emacs =
    if super.stdenv.isDarwin
    then
      storvik-emacs-base.overrideAttrs
        (old: {
          patches =
            (old.patches or [ ])
            ++ [
              # Fix OS window role so that yabai can pick up Emacs
              (super.fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
                sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
              })
              # Add setting to enable rounded window with no decoration (still
              # have to alter default-frame-alist)
              (super.fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/round-undecorated-frame.patch";
                sha256 = "sha256-iMn/aYtTKyJx3k1n2kVYU0TdriIFPjYSmKh9mEdXrpE=";
              })
              # Make Emacs aware of OS-level light/dark mode
              # https://github.com/d12frosted/homebrew-emacs-plus#system-appearance-change
              (super.fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
                sha256 = "3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
              })
            ];
        })
    else
      (storvik-emacs-base.override {
        withX = false;
        withPgtk = true;
        # lucid
        # withGTK2 = false;
        withGTK3 = true;
        withXinput2 = true;
      }).overrideAttrs (_: {
        configureFlags = [
          "--disable-build-details"
          "--with-modules"
          "--with-x-toolkit=gtk3"
          "--with-xft"
          "--with-cairo"
          "--with-xaw3d"
          "--with-native-compilation"
          "--with-imagemagick"
          "--with-xinput2"
        ];
      });

  storvik-emacs-withPackages =
    ((super.emacsPackagesFor storvik-emacs).emacsWithPackages (epkgs: [
      epkgs.jinx # necessary to install through nix to get libenchant integration working
      epkgs.treesit-grammars.with-all-grammars
      epkgs.mu4e
    ]));

}
