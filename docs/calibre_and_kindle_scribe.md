# Calibre, Kindle Scribe and KFX Output

Converting ebooks to KFX format solves problem of missing covers on sideloaded books on Kindle Scribe

Kindle Scribe uses MTP to transfer files


# Steps

## Enable gvfs

https://nixos.wiki/wiki/MTP

Enable gvfs to make sure Calibre can see and communicate with Kindle Scribe by enabling following service

```nix
services.gvfs.enable = true;
```

## Install packages

Make sure following packages are installed

´´´nix
environment.systemPackages = with pkgs; [
  calibre
  wineWowPackages.stable
  winetricks
];
```

## Download and install Kindle Previewer

Download windows version from url https://www.amazon.com/Kindle-Previewer/b?tag=mr060-20&ie=UTF8&node=21381691011

Install Kindle Previewer with following command

```bash
wine KindlePreviewerInstaller.exe
```

## Install and configure KFX Output plugin to Calibre

Open Calibre and navigate to Preferences. Under Plugins select Get new Plugins and search for XFX Output and install the plugin.

In Preferences. Under Output options select KFX Output and make sure Create personal document instead of book is selecteselect KFX Output and make sure Create personal document instead of book is selected

## Convert and send 

With gvfs enabled Calibre should be able to detect Kindle Scribe when it is connected with usb.

If you want to make sure that only kfx files are sent to the device you can configure what files can be sent.

In Device submenu click Configure this device and select only kfx and pdf for formats to send to the Kindle Scribe

Converting epubs to kfx seems to be pretty slow

