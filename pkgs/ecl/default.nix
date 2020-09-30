{ stdenv
, fetchgit
, libtool
, autoconf
, automake
, texinfo
, gmp
, mpfr
, libffi
, makeWrapper
, noUnicode ? false
, gcc
, threadSupport ? true
, useBoehmgc ? false
, boehmgc
}:

stdenv.mkDerivation rec {
  pname = "ecl";
  version = "20.4.24";

  src = fetchgit {
    rev = "${version}";
    url = "https://gitlab.com/embeddable-common-lisp/ecl/";
    sha256 = "0y4lcpgkl1609mmf0pnljp2g3x17258w9277dyaqssalax9jmgfp";
  };

  buildInputs = [
    libtool
    autoconf
    automake
    makeWrapper
    texinfo
  ];

  propagatedBuildInputs = [
    libffi
    gmp
    mpfr
    gcc
    # replaces ecl's own gc which other packages can depend on, thus propagated
  ] ++ stdenv.lib.optionals useBoehmgc [
    # replaces ecl's own gc which other packages can depend on, thus propagated
    boehmgc
  ];

  configureFlags = [
    (if threadSupport then "--enable-threads" else "--disable-threads")
    "--with-gmp-incdir=${gmp.dev}/include"
    "--with-gmp-libdir=${gmp.out}/lib"
    "--with-libffi-incdir=${libffi.dev}/include"
    "--with-libffi-libdir=${libffi.out}/lib"
  ]
  ++
  (stdenv.lib.optional (! noUnicode)
    "--enable-unicode")
  ;

  hardeningDisable = [ "format" ];

  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
    sed -e 's|${gmp.dev}/lib|${gmp.lib or gmp.out or gmp}/lib|g' -i $out/bin/ecl-config
    sed -e 's|${libffi.dev}/lib|${libffi.lib or libffi.out or libffi}/lib|g' -i $out/bin/ecl-config
    wrapProgram "$out/bin/ecl" \
      --prefix PATH ':' "${gcc}/bin" \
      --set LDFLAGS -L${gmp.lib or gmp.out or gmp}/lib \
      --set LDFLAGS -L${libffi.lib or libffi.out or libffi}/lib
  '';

  meta = {
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    homepage = "https://common-lisp.net/project/ecl/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
