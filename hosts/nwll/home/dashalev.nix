{ pkgs, inputs, ... }: {
  config.h = {
    dashalev.enable = true;
    steam.enable = true;

    xdg.configFiles = { "mpv/mpv.conf".source = ./mpv.conf; };

    packages = with pkgs; [
      foot
      pwvucontrol_git
      nautilus

      (pkgs.firefox-beta.override {
        nativeMessagingHosts =
          [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
        extraPrefs = ''
          lockPref("dom.disable_beforeunload", true);
          lockPref("browser.tabs.unloadOnLowMemory", false);
          lockPref("layout.css.devPixelsPerPx", "1.25");
          lockPref("browser.startup.page", 3);
          lockPref("browser.startup.homepage_override.mstone", "ignore");
          lockPref("browser.warnOnQuitShortcut", false);
          lockPref("browser.tabs.groups.smart.enabled", false);
          lockPref("browser.aboutConfig.showWarning", false);
          lockPref("general.autoScroll", true);
          lockPref("browser.urlbar.showSearchHistory", false);
          lockPref("browser.urlbar.suggest.history", false);
          lockPref("browser.theme.native-theme", false);
          lockPref("browser.theme.toolbar-theme", 2);
          lockPref("devtools.toolbox.host", "right");
        '';
        extraPolicies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisableFirefoxAccounts = true;
          DisplayBookmarksToolbar = "never";
          DisableMasterPasswordCreation = true;
          DisablePocket = true;
          DisableProfileImport = true;
          DisableSetDesktopBackground = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          SkipTermsOfUse = true;
          UserMessaging = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
          PictureInPicture = true;
          ShowHomeButton = false;
          DisableAppUpdate = true;
          ExtensionRecommendations = false;
          MoreFromMozilla = false;
          FirefoxLabs = false;
          FirefoxHome = {
            Search = true;
            TopSites = false;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
            Locked = true;
          };
          DisableFirefoxScreenshots = true;
          EnableTrackingProtection = true;
          ExtensionSettings = {
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              installation_mode = "force_installed";
              install_url =
                "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
              install_warning = false;
            };

            "uBlock0@raymondhill.net" = {
              install_url =
                "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
              allowed_in_private_browsing = true;
              install_warning = false;
            };

            "{84601290-bec9-494a-b11c-1baa897a9683}" = {
              install_url =
                "https://addons.mozilla.org/firefox/downloads/latest/ctrl-number-to-switch-tabs/latest.xpi";
              installation_mode = "force_installed";
              allowed_in_private_browsing = true;
              install_warning = false;
            };

            "{74145f27-f039-47ce-a470-a662b129930a}" = {
              install_url =
                "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
              installation_mode = "force_installed";
              install_warning = false;
            };
          };
        };
      })

      # aseprite
      # legcord
      wine64
      blender
      # krita
      # gimp3
      zathura

      signal-desktop-bin
      nvitop

      mullvad-vpn
      mpv
      # hdr for mpv
      vulkan-hdr-layer-kwin6
      qbittorrent

      mangohud
      torzu_git
      heroic
      cemu
      prismlauncher
    ];

    shell = {
      package = pkgs.fish;
      colour = "magenta";
      icon = "🗿";
    };

    wayland = { enable = true; };

    hyprland = {
      enable = true;
      extraConfig = ''
        monitor=HDMI-A-1,highrr,auto,1
        monitor=DP-0,highres@highrr,auto,1
        monitor=DP-1,highres@highrr,auto,1
        monitor=DP-2,highres@highrr,auto,1
        monitor=DP-3,highres@highrr,auto,1
        monitor=DP-4,highres@highrr,auto,1
        env = LIBVA_DRIVER_NAME,nvidia
        env = NVD_BACKEND,direct
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      '';
    };
  };
}
