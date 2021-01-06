[
  (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz)
  ./nixpkgsmaster
  ./ecl
  ./sbcl
  ./clpm
  ./pcl
  #./cloudcompare       # NOT WORKING
  #./gopls              # NOT WORKING, inconsistent vendoring
]
