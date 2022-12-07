{
  user.storvik.enable = true;
  gnome.enable = true;
  sway.enable = true;
  sound.enable = true;
  developer.enable = true;
  emacs = daemon = true;
  kanata.enable = true;
  texlive.enable = true;
  graphics.enable = true;
  media.enable = true;
  social.enable = true;
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
      "org" = {
        syncdirs = [
          {
            remote = "pcloud";
            source = "/home/storvik/developer/org/";
            dest = "pcloud:org/";
          }
        ];
      };
    };
  };
}
