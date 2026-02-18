{
    pkgs,
    config,
    lib,
    ...
}: let 
ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
    sops = {
            defaultSopsFile = ../../../../secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    };
    sops.secrets.email = {};

    users.users.gints = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = ifTheyExist [
            "wheel"
            "networkManager"
        ];
        packages = [pkgs.home-manager];
    };
    home-manager.users.gints = import ../../../../home/gints/${config.networking.hostName}.nix;

    
        


}