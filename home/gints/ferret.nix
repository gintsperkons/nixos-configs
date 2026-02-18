{ pkgs, ... }: 
{

  imports = [
    ./global
  ];

    xdg.configFile."niri/config.kdl" = {
    text = builtins.readFile ../config/niri/base.kdl;
    force = true;  # <- This allows Home Manager to overwrite the file
    };

  programs.git.enable = true;
  programs.zsh.enable = true;
  programs.alacritty.enable = true;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
