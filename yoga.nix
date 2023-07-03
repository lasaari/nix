{ pkgs, config, ... }:

{

  powerManagement.cpuFreqGovernor = "conservative";
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
    };
  };
  # services.auto-cpufreq = {
  #   enable = true;
  # };

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

