{ pkgs, inputs, ... }: {
  services = { mullvad-vpn = { enable = true; }; };

  environment.persistence."/nix/persist" = {
    directories = [
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
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    obs-studio = { enable = true; };
    # steam = {
    #   enable = true;
    #   extraCompatPackages = with pkgs; [ proton-ge-custom ];
    # };
    gamescope = {
      enable = true;
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
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "faeadnfmdfamenfhaipofoffijhlnkif" # into the black hole
        "occjjkgifpmdgodlplnacmkejpdionan" # autoscroll
      ];
      extraOpts = {
        "DefaultSearchProviderEnabled" = true;
        "DefaultSearchProviderSearchURL" = "google.com/search?q={searchTerms}";
        "DefaultSearchProviderSuggestURL" = null;
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
