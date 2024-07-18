{ config, pkgs, ... }: 

{
  imports = [
    ../usermodule.nix
  ];

  userModule.configByUsername = {
    "nicholastcs" = {
      enableSudo = true;
    };
    "work" = {
      enableSudo = false;
    };
  };

}