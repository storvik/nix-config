self: super:

{

  sbcl = super.sbcl.overrideAttrs (oldAttrs: rec {
    pname = "sbcl";
    version = "2.0.8";

    src = super.fetchurl {
      url = "mirror://sourceforge/project/sbcl/sbcl/${version}/${pname}-${version}-source.tar.bz2";
      sha256 = "1xwrwvps7drrpyw3wg5h3g2qajmkwqs9gz0fdw1ns9adp7vld390";
    };

  });

}
