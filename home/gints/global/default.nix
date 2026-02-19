{ pkgs, inputs, osConfig, ... }:

let
  # Pull latest nixpkgs for vscode
  unstable = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
  # Resolve which vscode extensions are provided by nixpkgs (unstable)
  vscodeExt = unstable.vscode-extensions;
  desiredExtensions = [
    "bbenoist.nix"
    "github.copilot-chat"
    "ms-vscode.cpptools"
    "usernamehw.errorlens"
    "esbenp.prettier-vscode"
    "aaron-bond.better-comments"
    "adpyke.vscode-sql-formatter"
    "ajshort.include-autocomplete"
    "amiralizadeh9480.laravel-extra-intellisense"
    "andreoneti.qml-formatter"
    "asvetliakov.vscode-neovim"
    "batisteo.vscode-django"
    "bibhasdn.django-html"
    "bigonesystems.django"
    "bmewburn.vscode-intelephense-client"
    "bracketpaircolordlw.bracket-pair-color-dlw"
    "bradlc.vscode-tailwindcss"
    "captncaps.ue4-snippets"
    "catppuccin.catppuccin-vsc"
    "chadalen.vscode-jetbrains-icon-theme"
    "cheshirekow.cmake-format"
    "chrmarti.regex"
    "codingyu.laravel-goto-view"
    "cschlosser.doxdocgen"
    "damms005.devdb"
    "delgan.qml-format"
    "devsense.composer-php-vscode"
    "devsense.intelli-php-vscode"
    "devsense.phptools-vscode"
    "devsense.profiler-php-vscode"
    "donjayamanne.githistory"
    "dsznajder.es7-react-js-snippets"
    "eamodio.gitlens"
    "ecmel.vscode-html-css"
    "editorconfig.editorconfig"
    "eliotvu.uc"
    "entuent.fira-code-nerd-font"
    "formulahendry.code-runner"
    "foxundermoon.shell-format"
    "geequlim.godot-tools"
    "glitchbl.laravel-create-view"
    "grapecity.gc-excelviewer"
    "gruntfuggly.todo-tree"
    "guyutongxue.cpp-reference"
    "hollowtree.vue-snippets"
    "holychicken99.premake-snippets"
    "hookyqr.minify"
    "ihunte.laravel-blade-wrapper"
    "ionutvmi.path-autocomplete"
    "jeff-hykin.better-cpp-syntax"
    "jnoortheen.nix-ide"
    "johnpapa.vscode-peacock"
    "keifererikson.nightfox"
    "kevinrose.vsc-python-indent"
    "llvm-vs-code-extensions.vscode-clangd"
    "maurodesouza.vscode-simple-readme"
    "mechatroner.rainbow-csv"
    "mikestead.dotenv"
    "mintlify.document"
    "mohd-akram.vscode-html-format"
    "mohsen1.prettify-json"
    "ms-azuretools.vscode-containers"
    "ms-dotnettools.csdevkit"
    "ms-dotnettools.csharp"
    "ms-dotnettools.vscode-dotnet-runtime"
    "ms-python.debugpy"
    "ms-python.isort"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.vscode-jupyter-slideshow"
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-ssh-edit"
    "ms-vscode.cpptools-themes"
    "ms-vscode.makefile-tools"
    "ms-vscode.powershell"
    "ms-vscode.remote-explorer"
    "msjsdiag.vscode-react-native"
    "naoray.laravel-goto-components"
    "onecentlin.laravel-blade"
    "onecentlin.laravel-extension-pack"
    "onecentlin.laravel5-snippets"
    "pgl.laravel-jump-controller"
    "phplasma.csv-to-table"
    "pnp.polacode"
    "rokoroku.vscode-theme-darcula"
    "rust-lang.rust-analyzer"
    "ryannaddy.laravel-artisan"
    "shufo.vscode-blade-formatter"
    "slevesque.shader"
    "steoates.autoimport"
    "streetsidesoftware.code-spell-checker"
    "suvam0451.sleeping-forest-ue4"
    "syler.sass-indented"
    "theqtcompany.qt"
    "theqtcompany.qt-core"
    "theqtcompany.qt-qml"
    "theqtcompany.qt-ui"
    "vscode-icons-team.vscode-icons"
    "vscodevim.vim"
    "vue.volar"
    "wayou.vscode-todo-highlight"
    "wlhe.c-cpp-snippets"
    "xdebug.php-debug"
    "yinfei.luahelper"
  ];
  getProvided = ext: pkgs.lib.attrByPath (builtins.split "." ext) null vscodeExt;
  nixProvided = builtins.concatLists (map (e: let v = getProvided e; in if v != null then [ v ] else []) desiredExtensions);
  marketplace = builtins.filter (e: getProvided e == null) desiredExtensions;
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
      # Use nix-provided extension packages when available
      extensions = nixProvided;
    };

    zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.theme = "agnoster";
    };

    # Godot handled via `home.packages` below (from unstable)
  };

  home = {
    username = "gints";
    homeDirectory = "/home/gints";
    stateVersion = "25.11";
    packages = [ unstable.godot ];

    # Helper to install Marketplace-only extensions (run manually)
    file.".local/bin/install-vscode-extensions".text = ''#!/bin/sh
#!/bin/sh
codeCmd=$(command -v code || command -v codium || true)
if [ -z "$codeCmd" ]; then
  echo "No VS Code binary found (code/codium). Run this after installing VS Code."
  exit 0
fi
set -e
for ext in ${builtins.concatStringsSep " " (map (e: "\"${e}\"") marketplace)}; do
  echo "Installing $ext"
  $codeCmd --install-extension "$ext" || true
done
'';
    file.".local/bin/install-vscode-extensions".executable = true;
    # Run the installer automatically on `home-manager switch`
    activation.install-vscode-extensions = ''
      if command -v code >/dev/null 2>&1 || command -v codium >/dev/null 2>&1; then
        "$HOME/.local/bin/install-vscode-extensions"
      else
        echo "No VS Code (code/codium) binary found; skipping extension install"
      fi
    '';
  };
}
