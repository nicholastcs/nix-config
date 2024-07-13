{ config, lib, pkgs, ... }:

{
  # virtualisation.docker.enable = true;

  # users.users.nicholastcs.extraGroups = [ "docker" ];

  # environment.sessionVariables = rec {
  #   NIXOS_OZONE_WL = "1";
  #   KUBE_EDITOR = "nano";
  # };

  # programs.bash.shellAliases = {
  #   k = "kubectl";
  # };

  # networking.extraHosts =
  # ''
  #   192.168.49.2 test-ingress.org
  # '';

  # users.users.nicholastcs.packages = with pkgs; [
  #   # For development
  #   go_1_21
  #   git

  #   # infrastructure
  #   minikube
  #   kubectl
  #   kubernetes-helm
  #   open-policy-agent
  #   mkcert
    
  #   (vscode-with-extensions.override {
  #     vscodeExtensions = with vscode-extensions; [
  #       bbenoist.nix
  #       golang.go
  #       hashicorp.terraform
  #       pkief.material-icon-theme
  #       redhat.vscode-yaml
  #       ms-kubernetes-tools.vscode-kubernetes-tools
  #       vscode-extensions.tsandall.opa
  #     ];
  #   })

  #   # IAC
  #   tenv
  # ];
}
