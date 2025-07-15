{
  programs = {
    chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "faeadnfmdfamenfhaipofoffijhlnkif" # into the black hole
        "occjjkgifpmdgodlplnacmkejpdionan" # autoscroll
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
