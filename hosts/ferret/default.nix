{ ... }:

{
  
  imports = [
    ../common/global
    ../common/users/gints
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "ferret";
  };

  services.tlp.enable = true;
  powerManagement.enable = true;
  services.libinput.enable = true;
  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
