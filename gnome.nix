{
  pkgs,
  ...
}: rec {
  home.packages = with pkgs.gnomeExtensions; [
    gsconnect
    tray-icons-reloaded
        # Include the results of the hardware scan.
  ];

  dconf.settings = {
    # Enable installed extensions
    "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) home.packages;

    "org/gnome/shell".disabled-extensions = [];


    # Configure GSConnect
    "org/gnome/shell/extensions/gsconnect".show-indicators = true;


  };
}
