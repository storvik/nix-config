# This overlay modifies PCLConfig
self: super:

{

  pcl = super.pcl.overrideAttrs (oldAttrs: rec {

    postInstall = ''
      sed -e 's/find_package(Boost 1.55.0 $[{]QUIET_[}] COMPONENTS system filesystem date_time iostreams)/find_package(Boost 1.55.0 \$\{QUIET_}) # COMPONENTS system filesystem date_time iostreams) # 2020.10.12 - Patch to make it work with nix/g' -i $out/share/pcl-1.11/PCLConfig.cmake
    '';

  });

}
