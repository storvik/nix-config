{
  user.storvik.enable = true;
  entertainment.enable = true;
  gnome.enable = true;
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
        dest = "/run/media/storvik/BACKUP/backup/photos/";
        delete = true;
      }
      {
        synctype = "rclone";
        source = "pcloud:eBooks/";
        dest = "/run/media/storvik/BACKUP/backup/eBooks/";
        delete = true;
      }
      {
        synctype = "rsync";
        source = "/run/media/storvik/BACKUP/backup/";
        dest = "/run/mnt/storvik-backup/";
        delete = true;
      }
      {
        synctype = "rclone";
        source = "/run/media/storvik/BACKUP/backup/";
        dest = "s3backup:storvik-backup/";
        delete = true;
      }
    ];
  };
}
