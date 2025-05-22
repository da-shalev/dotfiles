{ pkgs, inputs, ... }:
pkgs.firefox_nightly.override {
  nativeMessagingHosts =
    [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
  extraPrefs = builtins.readFile ./user.js;
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
}
