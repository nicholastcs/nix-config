{ config, pkgs, ... }: 

{
  imports = [
    ../usermodule.nix
  ];

  userModule.configByUsername = {
    "nicholastcs" = {
      enableSudo = true;
      enableVirtualBox = true;
    };
    "work" = {
      enableSudo = false;
    };
  };

}
