{ stdenv
, fetchgit
, sbcl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "clpm";
  version = "0.3.5";

  src = fetchgit {
    rev = "v${version}";
    url = "https://gitlab.common-lisp.net/clpm/clpm";
    sha256 = "0jivnnp3z148yf4c2nzzr5whz76w5kjhsb97z2vs5maiwf79y2if";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    sbcl
  ];

  buildInputs = [
    openssl.out
  ];

  libssl = openssl.out;

  buildPhase = ''
    cp $libssl/lib/libcrypto.so.* .
    cp $libssl/lib/libssl.so.* .

    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. sbcl --script scripts/build.lisp
  '';

  installPhase = ''
    INSTALL_ROOT=$out sh install.sh
  '';

  dontFixup = true;

  meta = {
    description = "Common Lisp Package Manager";
    homepage = "https://www.clpm.dev/";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ "Petter Storvik <petterstorvik@gmail.com>" ];
    platforms = stdenv.lib.platforms.all;
  };
}
