{ ... }: {
  services = { mullvad-vpn = { enable = true; }; };

  environment.persistence."/nix/persist" = {
    directories = [ "/etc/mullvad-vpn" "/var/cache/mullvad-vpn" ];
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    obs-studio = { enable = true; };
    gnupg.agent = { enable = true; };

    chromium = {
      enable = true;
      extensions = [
        # "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "occjjkgifpmdgodlplnacmkejpdionan" # autoscroll
        "faeadnfmdfamenfhaipofoffijhlnkif" # into the black hole
        "fmkadmapgofadopljbjfkapdkoienihi" # react dev tools
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
