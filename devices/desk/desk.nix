{ pkgs, config, ... }:


let
  unstable = import <unstable> {};
in
{
  networking.hostName = "desk"; # Define your hostname.
  # networking.interfaces.enp10s0.useDHCP = false;
  # networking.interfaces.enp10s0.ipv4.addresses = [ {
  #   address = "10.0.0.180";
  #   prefixLength = 24;
  # }];
  # networking.defaultGateway = "10.0.0.1";
  # networking.nameservers = [ "10.0.0.3" ];

  services.ollama.enable = true;
  services.ollama.acceleration = "rocm";
  services.ollama.listenAddress = "0.0.0.0:11434";

  # Disable suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    # unstable.lact

  ];

  # Enable amd gpu
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  hardware.opengl.driSupport = true; # This is already enabled by default
  hardware.opengl.driSupport32Bit = true; # For 32 bit applications

}

