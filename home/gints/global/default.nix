{ pkgs, inputs, osConfig, ... }:

let
  # Pull latest nixpkgs for vscode
  unstable = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
in
{
  programs = {
    home-manager.enable = true;
    git = {
        enable = true;
        settings = {
        user = {
            name  = "Gints";
          email = "store --file ${osConfig.sops.secrets.email.path}";
        };
        init.defaultBranch = "main";
        };
    };

    vscode = {
      enable = true;
      package = unstable.vscode;
      profiles.default.extensions = with unstable.vscode-extensions; [
        bbenoist.nix
        github.copilot-chat
        usernamehw.errorlens
        esbenp.prettier-vscode
      ];
    };
  };

  home = {
    username = "gints";
    homeDirectory = "/home/gints";
    stateVersion = "25.11";
  };
}
