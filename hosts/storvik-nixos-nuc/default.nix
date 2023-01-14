{
  user.storvik.enable = true;
  entertainment.enable = true;
  # gnome.enable = true;
  sound.enable = true;
  emacs.daemon = true;
  media.enable = true;
  developer.nix.enable = true;
  remotelogin.enable = true;
  virtualization.enable = true;
  work.enable = true;
  backup = {
    enable = true;
    folders = [
      {
        synctype = "rclone";
        source = "pcloud:photos/";
        dest = "/run/mnt/wd-external/backup/photos/";
        delete = true;
      }
      {
        synctype = "rclone";
        source = "pcloud:eBooks/";
        dest = "/run/mnt/wd-external/backup/eBooks/";
        delete = true;
      }
      {
        synctype = "rsync";
        source = "/run/mnt/wd-external/backup/";
        dest = "/run/mnt/mybook-storvik-backup/";
        delete = true;
      }
      {
        synctype = "rclone";
        source = "/run/mnt/wd-external/backup/";
        dest = "s3backup:storvik-backup/";
        delete = true;
      }
    ];
  };
}
