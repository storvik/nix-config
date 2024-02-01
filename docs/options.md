## _module\.args

Additional arguments passed to each module in addition to ones
like ` lib `, ` config `,
and ` pkgs `, ` modulesPath `\.

This option is also available to all submodules\. Submodules do not
inherit args from their parent module, nor do they provide args to
their parent module or sibling submodules\. The sole exception to
this is the argument ` name ` which is provided by
parent modules to a submodule and contains the attribute name
the submodule is bound to, or a unique generated name if it is
not bound to an attribute\.

Some arguments are already passed by default, of which the
following *cannot* be changed with this option:

 - ` lib `: The nixpkgs library\.

 - ` config `: The results of all options after merging the values from all modules together\.

 - ` options `: The options declared in all modules\.

 - ` specialArgs `: The ` specialArgs ` argument passed to ` evalModules `\.

 - All attributes of ` specialArgs `
   
   Whereas option values can generally depend on other option values
   thanks to laziness, this does not apply to ` imports `, which
   must be computed statically before anything else\.
   
   For this reason, callers of the module system can provide ` specialArgs `
   which are available during import resolution\.
   
   For NixOS, ` specialArgs ` includes
   ` modulesPath `, which allows you to import
   extra modules from the nixpkgs package tree without having to
   somehow make the module aware of the location of the
   ` nixpkgs ` or NixOS directories\.
   
   ```
   { modulesPath, ... }: {
     imports = [
       (modulesPath + "/profiles/minimal.nix")
     ];
   }
   ```

For NixOS, the default value for this option includes at least this argument:

 - ` pkgs `: The nixpkgs package set according to
   the ` nixpkgs.pkgs ` option\.



*Type:*
lazy attribute set of raw value

*Declared by:*
 - [\<nixpkgs/lib/modules\.nix>](https://github.com/NixOS/nixpkgs/blob//lib/modules.nix)



## storvik\.enableWSL



Enable WSL specific config\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.autoLoginUser



Enable autologin for user\.



*Type:*
null or string



*Default:*
` null `



*Example:*
` "retro" `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.backup\.enable



Whether to enable Enable nightly backup\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.backup\.folders



Attribute sets that describes directories that should be
backed up\. Every string should match the string expected by
rclone or rsync command\.



*Type:*
list of (submodule)

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.backup\.folders\.\*\.delete



If true, delete files in destination



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.backup\.folders\.\*\.dest



Destination directory to be synced into\.



*Type:*
string



*Example:*
` "pcloud:folder/" `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.backup\.folders\.\*\.source



Source directory to be synced\.



*Type:*
string



*Example:*
` "/home/user/folder/" `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.backup\.folders\.\*\.synctype



Should rclone or rsync be used\.



*Type:*
string



*Example:*
` "rclone" `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.desktop



Which desktop to use, if any\.



*Type:*
one of “none”, “gnome”, “hyprland”



*Default:*
` "none" `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.disableLoginManager



Disable login manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.kanata\.enable



Enable kanata, a software keyboard remapper\.
https://github\.com/jtroo/kanata



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.kanata\.devices



List of devices used by kanata



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.remoteLogon



Enable SSH\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.retroarch



Enable retroarch\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)



## storvik\.sound



Enable sound using pipewire\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options\.nix](file:///nix/store/czabybq2xksyxrjm7j7azjlr9a6d9gr2-source/modules/nixos/options.nix)


