{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lasse = {
    isNormalUser = true;
    description = "Lasse";
    extraGroups = [ "networkmanager" "wheel" "libvirtd"];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  programs.steam.enable = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.lasse = { pkgs, ... }: {

    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      # Terminal
      tmux
      zsh
      fzf
      zsh-powerlevel10k

      # Launcher
      sway-launcher-desktop

      # Browsers
      firefox
      chromium

      # Video
      mpv

      # Notes
      obsidian

      # Communication
      thunderbird
      discord
      fractal
 
      # Steam
      steam

      # IDE
      neovim
      ripgrep
      tree-sitter

      # Dev tools
      gcc
      glibc.static
      nodejs-18_x
      ansible
      terraform

      # Utilities 
      keepassxc
      bat
      cloudflared
      syncthing
      unstable.syncthingtray

      xclip
      wl-clipboard

      # Photography
      darktable

      # Fonts
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    # Syncthing
    services.syncthing = {
      enable = true;
      tray.enable = false;
    };

    # ZSH
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      autocd = true;
      dotDir = ".config/zsh";
      shellAliases = {
        ll = "ls -lh";
        update = "sudo nix-channel --update && sudo nixos-rebuild switch";
        cat = "bat";
      };
      plugins = with pkgs; [

        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }

      ];

      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source $HOME/.config/zsh/.p10k.zsh
      '';
    };

    home.file.".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    home.file.".config/sway" = {
        source = ./sway;
        recursive = true;
      };

    # Configure alacritty

    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
          opacity = 0.9;

          decorations = "full";
        };
        font = {
          normal = {
            family = "FiraCode Nerd Font";
            style = "regular";
          };
          bold = {
            family = "FiraCode Nerd Font";
            style = "regular";
          };
          italic = {
            family = "FiraCode Nerd Font";
            style = "regular";
          };
          bold_italic = {
            family = "FiraCode Nerd Font";
            style = "regular";
          };
          size = 12.00;
        };
        shell = {
          program = ''${pkgs.zsh}/bin/zsh'';
        };
      };
    };
    # Cursor fix
    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
    };
    # Variables
    home.sessionVariables = {
      EDITOR = "nvim";
      SHELL = ''${pkgs.zsh}/bin/zsh'';
      NIXPKGS_ALLOW_UNFREE = "1";
      MOZ_ENABLE_WAYLAND = "1";

    };
  };

}

