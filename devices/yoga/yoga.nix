{ pkgs, config, ... }:

{


  networking.hostName = "yoga"; # Define your hostname.
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
  };

  boot.kernelParams = [
    "initcall_blacklist=acpi_cpufreq_init"
    "amd_pstate.shared_mem=1"
    "amd_pstate=active"
  ]; 
  boot.kernelModules = [ "amd-pstate" ];


  hardware.sensor.iio.enable = true;

  environment.systemPackages = with pkgs; [
    iio-sensor-proxy
  ];
}

