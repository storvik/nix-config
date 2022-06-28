{
  user.storvik.enable = true;
  gnome.enable = true;
  sound.enable = true;
  developer.enable = true;
  emacs = {
    nativeComp = true;
    daemon = true;
  };
  kmonad.enable = true;
  texlive.enable = true;
  graphics.enable = true;
  media.enable = true;
  social.enable = true;
  #work.enable = true;
  #forensics.enable = true;
  #forensics.modules = [ "reverse" ];
  #rclone = {
  #  enable = true;
  #  syncs = {
  #    "svartisenfestivalen" = {
  #      syncdirs = [
  #        {
  #          remote = "pcloud";
  #          source = "/home/storvik/developer/svartisenfestivalen/";
  #          dest = "pcloud:svartisenfestivalen/";
  #        }
  #      ];
  #    };
  #  };
  #};
}
