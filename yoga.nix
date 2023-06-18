{ pkgs, config, ... }:

{

  powerManagement.cpuFreqGovernor = "conservative";
  services.tlp = {
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
    };
  };

  boot.kernelParams = [
    "initcall_blacklist=acpi_cpufreq_init"
    "amd_pstate.shared_mem=1"
  ];
  boot.kernelModules = [ "amd-pstate" ];
}

