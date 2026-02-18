{ pkgs, zen-browser, ... }:

{
  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    swaylock
    swayidle
    mako
    xwayland-satellite
    sops
    age

    zen-browser.packages.${pkgs.system}.default
  ];
}
