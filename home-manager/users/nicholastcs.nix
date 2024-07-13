{ config, pkgs, ... }:

{
  users.users.nicholastcs = {
    isNormalUser = true;
    description = "nicholastcs";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
      neofetch
      keepassxc
    ];
  };

  virtualisation.docker.enable = true;

  home-manager.users.nicholastcs = { pkgs, ... }: {
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
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
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
      ];
    };


    home.stateVersion = "24.05";
  };
}
