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
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.designer



Enable graphics designer tools\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.desktop



Which desktop environment to use, if any\.



*Type:*
one of “none”, “gnome”, “hyprland”



*Default:*
` "none" `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.devtools\.enable



Enable developer tooling\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.devtools\.disabledModules



List of strings that describes developer modules to disable\.

Possible values:
\[ “android” “c” “go” “nix” “web” ]



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.disableEmacsDaemon



Disable Emacs daemon\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.disableEmail



Disable email config



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.disableGPG



Disable GPG, can be useful on server or live host\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.disableNerdfonts



Disable nerdfonts, useful when system is supposed to be deployed with deploy-rs\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.forensics\.enable



Enable forensic tools\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.forensics\.disabledModules



List of strings that describes forensic modules to disable\.

Possible values:
\[ “reverse” “recon” “exploit” ]



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.gitSigningKey



Git signing key, can be omitted using null value\.

> If using subkey, remember to append ` ! ` to key ID\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.gnomeAutostartPkgs



*Type:*
list of package



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.media



Enable programs that can be used to multimedia content, audio and video\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.social



Enable social programs, such as signal\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.texlive



Enable texlive, installing texlive-full\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)



## storvik\.waylandTools



Enable collection of useful wayland tools\.

Wayland tools includes:

 - imv (image viewer)
 - sioyek (pdf viewer)



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options\.nix](file:///nix/store/c4c884qfrg541zw7g1k325bzlz7qlryr-source/modules/hm-modules/options.nix)


