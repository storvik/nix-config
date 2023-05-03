self: super:

{

  # Could not override cargoHash
  # https://github.com/NixOS/nixpkgs/issues/107070
  kanata = super.pkgs.rustPlatform.buildRustPackage {
    pname = "kanata";
    version = "1.4.0-pre";

    src = super.fetchFromGitHub {
      owner = "jtroo";
      repo = "kanata";
      rev = "4738e4f37d0ada601b128d5a138cd83c22c96ecb";
      sha256 = "sha256-vlrqBi/E7t/p74EZXgt0o2TEgOnBDGMsAT0wYL2z5WM=";
    };
    cargoHash = "sha256-X5Ozlhq63LID+W4UHgJYfYXqzVh8z8jrlON3B/MFTRw=";

    buildFeatures = "cmd";

    nativeBuildInputs = [ super.pkgs.pkg-config ];

    buildInputs = [ super.pkgs.libevdev ];

  };


}
