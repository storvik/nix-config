self: super:

{

  # Could not override cargoHash
  # https://github.com/NixOS/nixpkgs/issues/107070
  kanata = super.pkgs.rustPlatform.buildRustPackage {
    pname = "kanata";
    version = "1.0.6-pre";

    src = super.fetchFromGitHub {
      owner = "jtroo";
      repo = "kanata";
      rev = "f431cace01af358847a27901f72fa26590c613b2";
      sha256 = "sha256-QtwN065BjRXc7swqKyCuD5ggrVSV6bhwirgh0s4sLjY=";
    };

    cargoHash = "sha256-wzGeOF3YN4kMfvHfbCwTxzj4JuWFfCWAVSroaHj5lbM=";

    buildFeatures = "cmd";

    nativeBuildInputs = [ super.pkgs.pkg-config ];

    buildInputs = [ super.pkgs.libevdev ];

  };


}
