# Home Manager config
{ config, pkgs, ...}:

{
  home.username = "ondra";
  home.homeDirectory = "/home/ondra";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # user pkgs
    zsh-powerlevel10k
    fzf
    nodejs
  ];


  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };


  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "opecko";
      user.email = "opavlat5@gmail.com";
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
    
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON ''
    {
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "version": 4,
  "final_space": true,
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "session",
          "style": "plain",
          "powerline_symbol": "\ue0d2",
          "template": "{{ .UserName }} ",
          "foreground": "green",
          "background": "transparent"
        },
        {
          "type": "text",
          "style": "plain",
          "powerline_symbol": "\ue0d2",
          "template": "in ",
          "foreground": "#ffffff",
          "background": "transparent"
        },
        {
          "type": "path",
          "style": "plain",
          "powerline_symbol": "\ue0d2",
          "template": "{{ .Path }}",
          "foreground": "cyan",
          "background": "transparent"
        }
      ]
    },
    {
      "type": "rprompt",
      "alignment": "right",
      "segments": [
        {
          "type": "status",
          "style": "plain",
          "powerline_symbol": "\ue0b0",
          "template": " {{ if eq .Code 0 }}\uf00c{{ else }}\uf071 {{ .Code }}{{ end }} ",
          "foreground": "#ffffff",
          "background": "transparent"
        }
      ]
    },
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "text",
          "style": "plain",
          "powerline_symbol": "\ue0d2",
          "template": "$",
          "foreground": "p:text-light",
          "background": "transparent"
        }
      ],
      "newline": true
    }
  ],
  "palette": {
    "text-light": "#ffffff",
    "path-bg": "#61AFEF",
    "git-bg": "#98C379"
  }
}

    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      ls = "eza";
      ll = "eza -l --git";
      la = "eza -la --git";
      tree = "eza --tree";
      cat = "bat";

      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#ONDRA-PC";
      mpdfix = "systemctl --user restart mpd-mpris.service && systemctl --user restart mpd-discord-rpc.service";
    };

    plugins = [
#      {
#        name = "powerlevel10k";
#        src = pkgs.zsh-powerlevel10k;
#        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
#      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = ''
      # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      autoload -Uz compinit && compinit

      export FZF_DEFAULT_OPTS="
        --color=fg:#d8dee9,bg:#2e3440,hl:#88c0d0
        --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#88c0d0
        --color=info:#ebcb8b,prompt:#81a1c1,pointer:#bf616a
        --color=marker:#a3be8c,spinner:#b48ead,header:#a3be8c
      "

      # Blinking bar cursor, reset after each command
      echo -ne '\e[5 q'
      precmd() { echo -ne '\e[5 q' }

      # Basic keys
      bindkey '^[[3~'   delete-char           # Delete
      bindkey '^[[H'    beginning-of-line      # Home
      bindkey '^[[F'    end-of-line            # End
      bindkey '^[[1~'   beginning-of-line      # Home (alt)
      bindkey '^[[4~'   end-of-line            # End (alt)

      # Ctrl+arrows
      bindkey '^[[1;5C' forward-word           # Ctrl+Right
      bindkey '^[[1;5D' backward-word          # Ctrl+Left

      # Shift+arrows — selection
      select-backward-char() { REGION_ACTIVE=1; zle backward-char }
      select-forward-char()  { REGION_ACTIVE=1; zle forward-char  }
      zle -N select-backward-char
      zle -N select-forward-char
      bindkey '^[[1;2D' select-backward-char   # Shift+Left
      bindkey '^[[1;2C' select-forward-char    # Shift+Right

      # Ctrl+Shift+arrows — word selection
      select-backward-word() { REGION_ACTIVE=1; zle backward-word }
      select-forward-word()  { REGION_ACTIVE=1; zle forward-word  }
      zle -N select-backward-word
      zle -N select-forward-word
      bindkey '^[[1;6D' select-backward-word   # Ctrl+Shift+Left
      bindkey '^[[1;6C' select-forward-word    # Ctrl+Shift+Right

      # Highlight selected region (Nord colors)
      zle_highlight=(region:bg=#3b4252,fg=#e5e9f0)

      ffcd() {
        local dir
        dir=$(find ''${1:-.} -type d 2>/dev/null | fzf) && cd "$dir"
      }

      ffe() {
        local file
        file=$(fzf) && ''${EDITOR:-nvim} "$file"
      }

      ffkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf | awk '{print $2}')
        [[ -n "$pid" ]] && kill -9 "$pid"
      }
    '';
  };
}
