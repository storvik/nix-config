(self: super: with super; {

  pkgs-stable = import (fetchTarball http://nixos.org/channels/nixos-20.09/nixexprs.tar.xz)
    {
      config = self.config;
    };

  pkgs-master = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz)
    {
      config = self.config;
    };
})
