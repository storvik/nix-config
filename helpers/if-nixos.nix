# Source: https://www.reddit.com/r/NixOS/comments/ae9q01/how_to_os_from_inside_a_nix_file/
let NIXOS = if (builtins.elemAt (builtins.match "NAME\=([A-z]*).*" (builtins.readFile /etc/os-release)) 0 == "NixOS") then true else false; in NIXOS
