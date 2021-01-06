source $stdenv/setup

cp -r $src/* .
chmod -R 755 .

cp $libssl/lib/libcrypto.so.1.1 .
cp $libssl/lib/libssl.so.1.1 .

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. sbcl --script scripts/build.lisp

INSTALL_ROOT=$out sh install.sh
