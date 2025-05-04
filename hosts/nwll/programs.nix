{ ... }: {
  services = { mullvad-vpn = { enable = true; }; };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/mullvad-vpn"
      "/var/cache/mullvad-vpn"
    ];
  };

  programs = {
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
