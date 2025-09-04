{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the "hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    nerd-fonts.jetbrains-mono
    nil
    skim
    bat
    git
    gh
    delta
    vscode-langservers-extracted
    btop
    ripgrep
    git-filter-repo

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
 fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/wolfey/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = ''
      $username$hostname$directory$git_branch$git_state$git_status$cmd_duration
      $python$character
      '';
      directory.style = "blue";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      python = {
        format = "[$virtualenv]($style)";
        style = "bright-black";
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -x PATH $HOME/.nix-profile/bin $PATH
      set -x PATH /nix/var/nix/profiles/default/bin $PATH
      set -x PATH /usr/local/go/bin $PATH
      set -x PATH /usr/local/odin $PATH
      set -x PATH $HOME/go/bin $PATH
      set -x PATH /usr/local/ols $PATH
      set -x PATH /usr/local/zig $PATH
      set -x PATH /usr/local/renderdoc/bin $PATH
      starship init fish | source
    '';
  };

  
  programs.alacritty = {
    enable = true;
    package = pkgs.emptyDirectory;
    settings = {
        terminal.shell = "${pkgs.fish}/bin/fish";
        font = {
          normal = { family = "JetBrainsMono Nerd Font"; };          
          size = if pkgs.stdenv.isDarwin then 24 else 16;
        };
        window.padding = {
          x = 10;
          y = 10;
        };
        window.option_as_alt = "Both";
    };
  };
  

  programs.helix = {
    enable = true;
    settings = {
      theme = "darcula";
      editor = {
        line-number = "relative";
        mouse = true;
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      keys.normal = {
        X = "select_line_above";
        x = "select_line_below";
      };
      editor.inline-diagnostics = {
        cursor-line = "hint";
        other-lines = "error";
      };
    };
    languages = {
      language = [{
        name = "json";
        indent = { tab-width = 4; unit = " "; };
      }];
    };
  };
  
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      set -sg escape-time 0
      set-option -g mouse on
      set-option -g status-bg colour237
      set-option -g status-fg colour250
      set-window-option -g mode-keys vi
    '';
  };
}
