{
  user.storvik.enable = true;
  genericLinux.enable = true;
  developer.enable = true;
  emacs = {
    nativeComp = true;
    daemon = true;
  };
  texlive.enable = true;
  graphics.enable = true;
  media.enable = true;
  social.enable = true;
  work.enable = true;
  rclonesync.enable = true;
  rclonesync.syncdirs = [
    {
      remote = "pcloud";
      source = "/home/storvik/developer/svartisenfestivalen/";
      dest = "svartisenfestivalen/";
    }
    {
      remote = "pcloud";
      source = "/home/storvik/developer/org/";
      dest = "org/";
    }
  ];
}
