{
  user.storvik.enable = true;
  genericLinux.enable = true;
  developer.enable = true;
  emacs = {
    nativeComp = true;
    daemon = true;
  };
  kanata.enable = true;
  texlive.enable = true;
  graphics.enable = true;
  media.enable = true;
  social.enable = true;
  work.enable = true;
  forensics.enable = true;
  forensics.modules = [ "reverse" ];
  rclone = {
    enable = true;
    syncs = {
      "svartisenfestivalen" = {
        syncdirs = [
          {
            remote = "pcloud";
            source = "/home/storvik/developer/svartisenfestivalen/";
            dest = "pcloud:svartisenfestivalen/";
          }
        ];
      };
    };
  };
}
