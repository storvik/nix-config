{ stdenv
, fetchgit
, sbcl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "clpm";
  version = "0.3.5";

  src = fetchgit {
    rev = "ab69cf9e3ac506ae2f139c6967f07aad20e87c38";
    url = "https://gitlab.common-lisp.net/clpm/clpm";
    sha256 = "0icak8aqd6ljvxgcw8shwx3jhbzlbppy67d66s91b47ygp1qvvra";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    sbcl
  ];

  buildInputs = [
    openssl.out
  ];

  builder = ./builder.sh;

  libssl = openssl.out;

  meta = {
    description = "Common Lisp Package Manager";
    homepage = "https://www.clpm.dev/";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ "Petter Storvik <petterstorvik@gmail.com>" ];
    platforms = stdenv.lib.platforms.all;
  };
}
