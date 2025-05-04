{ config, lib, pkgs, ... }: {
  h = {
    git = {
      enable = true;
      config = "${builtins.readFile ./git/config}";
      ignore = "${builtins.readFile ./git/ignore}";
    };

    shell.aliases = { s = "${lib.getExe pkgs.lsd} -lA"; };

    packages = with pkgs; [ tmux-sessionizer ];

    tmux = {
      enable = true;
      extraConfig = "${builtins.readFile ./tmux.conf}";
    };

    fish = {
      enable = true;
      extraInteractive = ''
        ${builtins.readFile ./config.fish}

        function fzf_cmd
          set -x fzfn (${lib.getExe pkgs.fd} . ~ --hidden | ${
            lib.getExe pkgs.fzf
          })
          if test -z $fzfn
            return
          else if test -d $fzfn
            cd $fzfn
          else
            cd $(dirname $fzfn)
            nvim $(basename $fzfn)
          end

          echo -e ""
          fish_prompt
        end

        function fish_mode_prompt
        end

        function fish_prompt
          printf '%s%s%s %s%s%s\n%s ' \
            (set_color "${config.h.shell.colour}")(whoami) \
            (set_color "brwhite")@ \
            (set_color "bryellow")(hostname) \
            (set_color "brgreen") (prompt_pwd) \
            (set_color "brred"; fish_git_prompt) \
            ${config.h.shell.icon}
        end
      '';
    };
  };

  environment.etc = {
    "${config.h.profile.config}/ghostty/config".source = ./ghostty.conf;
    "${config.h.profile.config}/fish/themes/fishsticks.theme".source =
      ./fishsticks.theme;
    "${config.h.profile.config}/tms/config.toml".text = ''
      excluded_dirs = [".direnv"]

      [[search_dirs]]
      path = "${config.systemGenesis.config}/"
      depth = 5

      [[search_dirs]]
      path = "${config.h.path}/media/"
      depth = 20
    '';
  };
}
