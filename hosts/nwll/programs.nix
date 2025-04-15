{ pkgs, inputs, ... }: {
  services = {
    # postgresql = { enable = false; };
    mullvad-vpn = { enable = true; };
  };

  environment.persistence."/nix/persist" = {
    directories = [
      # "/var/lib/logmein-hamachi"
      "/etc/mullvad-vpn"
      "/var/cache/mullvad-vpn"
    ];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      river.default = [ "wlr" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };

  programs = {
    # haguichi.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    obs-studio = { enable = true; };
    adb.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-custom ];
      gamescopeSession = {
        enable = true;
        args = [ "--rt" "--hdr-enabled" "-W 3840" "-H 2160" ];
      };
    };
    gamescope = {
      enable = true;
      # package = pkgs.gamescope_git;
    };
    nh = {
      enable = true;
      clean.enable = true;
    };
    gnupg.agent = { enable = true; };
    fish.enable = true;
    chromium = {
      enable = true;
      extensions = [
        # "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "faeadnfmdfamenfhaipofoffijhlnkif" # into the black hole
      ];
      extraOpts = {
        "DefaultSearchProviderEnabled" = true;
        "BrowserLabsEnabled" = false;
        "GenAiDefaultSettings" = 2;
        "BookmarkBarEnabled" = false;
        "ImportBookmarks" = false;
        "PromotionsEnabled" = false;
        "BrowserSignin" = 0;
        "DefaultBrowserSettingEnabled" = false;
        "AutoSignInEnabled" = true;
        "BrowserAddPersonEnabled" = false;
        "BrowserGuestModeEnabled" = false;
        "UserFeedbackAllowed" = false;
        "BackgroundModeEnabled" = false;
        "MetricsReportingEnabled" = false;
        "BlockExternalExtensions" = true;
        "AutofillAddressEnabled" = false;
        "AutofillCreditCardEnabled" = false;
        "PasswordManagerEnabled" = false;
        "PromptForDownloadLocation" = true;
        "SyncDisabled" = true;
        "SpellcheckEnabled" = true;
      };
    };
  };
}
