{ pkgs, ... }: {
  services = {
    # postgresql = { enable = false; };
    mullvad-vpn.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common = {
      river = [ "wlr" ];
      hyprland = [ "hyprland" ];
    };
    extraPortals =
      [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  programs = {
    obs-studio = { enable = true; };
    adb.enable = true;
    gamemode.enable = true;
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
      # package = pkgs.gamescope-wsi_git;
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
