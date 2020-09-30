self: super:

{

  ## NOT WORKING
  cloudcompare = super.cloudcompare.overrideAttrs (oldAttrs: rec {
    version = "2.11.2";
    src = super.fetchFromGitHub {
      owner = "CloudCompare";
      repo = "CloudCompare";
      rev = "v${version}";
      sha256 = "1p93qrmhphvdsaqn99b4mw8i0vkzzvyg1hw7pr2r0732i3qwca1n";
      fetchSubmodules = true;
    };
  });

}
