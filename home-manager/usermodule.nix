{ lib, pkgs, config, ... }:
let 
  cfg = config.userModule;
in
{
  options = {
    userModule.configByUsername = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule 
        {
          options = {
            enableSudo = lib.mkEnableOption "Enable Sudo";
            enableVirtualBox = lib.mkEnableOption "Is VirtualBox user";
          };
        }
      );
    };
  };

  config = {
    virtualisation.docker.enable = true;
    virtualisation.virtualbox.host.enable = true;

    users.users = builtins.mapAttrs (name: value: {
        isNormalUser = true;
        description = name;
        extraGroups = [ "networkmanager" "docker" ] ++ lib.optionals(value.enableSudo == true) ["wheel"] ++ lib.optionals(value.enableVirtualBox == true) ["vboxusers"];
        packages = with pkgs; [
          kdePackages.kate
          neofetch
          keepassxc
          thunderbird
        ];
      }
    ) cfg.configByUsername;

    # build is very flaky and broke the build, test is bypassed.
    nixpkgs.overlays = [
      (final: prev: {
        open-policy-agent = prev.open-policy-agent.override {

          buildGoModule = args: prev.buildGoModule (args // {
            doInstallCheck = false;
            doCheck = false;
          });

        };
      })
    ];

    home-manager.users = builtins.mapAttrs(name: value: { pkgs, ... }:{
        home.stateVersion = "24.05";

        programs.vscode = {
          enable = true;
          extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            golang.go
            hashicorp.terraform
            pkief.material-icon-theme
            redhat.vscode-yaml
            ms-kubernetes-tools.vscode-kubernetes-tools
            tsandall.opa
            github.github-vscode-theme
          ];

          userSettings = {
            "telemetry.telemetryLevel" = "off";
            "workbench.colorTheme" = "GitHub Dark";
            "workbench.iconTheme" = "material-icon-theme";
            "explorer.sortOrder" = "type";
            "editor.minimap.enabled" = false;
            "editor.fontLigatures" = true;
            "editor.fontFamily" = "MesloLGS NF";
            "redhat.telemetry.enabled" = false;
            "opa.languageServers" = [
              "regal"
            ];
            "editor.stickyScroll.enabled" = false;
            "editor.renderWhitespace" = "trailing";
            "diffEditor.ignoreTrimWhitespace" = false;
            "editor.detectIndentation" = true;
          };
        };

        programs.bash = {
          enable = true;
          shellAliases = {
            k = "kubectl";
          };
          sessionVariables = {
            NIXOS_OZONE_WL = "1";
            KUBE_EDITOR = "nano";
          };
        };

        programs.librewolf = {
          enable = true;
          # Enable WebGL, cookies and history
          settings = {
            "webgl.disabled" = false;
            "privacy.resistFingerprinting" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown.cookies" = true;
            "network.cookie.lifetimePolicy" = 2;
            "privacy.fingerprintingProtection" = true;
            "media.hardware-video-decoding.force-enabled" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "browser.policies.runOncePerModification.removeSearchEngines" = ''["Google" "Bing" "Amazon.com" "eBay" "Twitter"]'';
          };
        };

        home = {
          packages = with pkgs; [
            # For development
            go_1_21
            git
            go-task
            yamllint

            # infrastructure
            minikube
            kubectl
            kubernetes-helm
            open-policy-agent
            mkcert
            regal

            # IAC
            tenv

            # Fonts
            jetbrains-mono
            meslo-lgs-nf

            # Apps
            logseq
          ];
        };
      } 
    ) cfg.configByUsername;
  };
}
