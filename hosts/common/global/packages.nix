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
    scons
    gcc
    clang
    clang-tools
    llvm
    sourcegit
    zen-browser.packages.${pkgs.system}.default
  ];
}
