self: super:

{

  # Add custom ecl package, the one in nixpkgs is outdated
  ecl = super.callPackage ../../pkgs/ecl { };

}
