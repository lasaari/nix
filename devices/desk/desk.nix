{ pkgs, config, ... }:


let
  unstable = import <unstable> {};

  # Get ollama 1.30
  pkgs-with-old-ollama = import (builtins.fetchGit {
    name = "old-ollama";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "da83c7ae68df9561b49598292b38294bca868dc9";
  }) {
    config = config.nixpkgs.config;
  };
in
{
  networking.hostName = "desk";

  powerManagement.enable = true;

  # Enable Ollama

  services.ollama.enable = true;
  services.ollama.acceleration = "rocm";
  services.ollama.listenAddress = "0.0.0.0:11434";
  services.ollama.package = pkgs-with-old-ollama.ollama;

  # Disable suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget

  ];

  boot.kernelParams = [
    "initcall_blacklist=acpi_cpufreq_init"
    "amd_pstate.shared_mem=1"
    "amd_pstate=active"
    "pcie_aspm=off"

  ]; 
  boot.kernelModules = [ "amd-pstate" ];

  # Enable amd gpu
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocm-opencl-runtime
  ];
  hardware.opengl.driSupport = true; # This is already enabled by default
  hardware.opengl.driSupport32Bit = true; # For 32 bit applications

}

