self: super:

{

  # Could not override cargoHash
  # https://github.com/NixOS/nixpkgs/issues/107070
  kanata = super.pkgs.rustPlatform.buildRustPackage {
    pname = "kanata";
    version = "1.0.8-pre";

    src = super.fetchFromGitHub {
      owner = "jtroo";
      repo = "kanata";
      rev = "50044b415c79ff9fb86b12abc4297421589632fe";
      sha256 = "sha256-v4iW6wtNwnRGWuKt3t1DspYLfcRe8ghqsu+cIyXaArc=";
    };
    cargoHash = "sha256-8xJfXT9QlAFfy6B1xxEQzBgR8VFZn9b1cHtDIRXfYPo=";

    buildFeatures = "cmd";

    nativeBuildInputs = [ super.pkgs.pkg-config ];

    buildInputs = [ super.pkgs.libevdev ];

  };


}
