{
  extraPrefs = builtins.readFile ./user.js;
  extraPolicies = {
    SearchEngines = {
      Add = [
        {
          Name = "Brave Search";
          URLTemplate = "https://search.brave.com/search?q={searchTerms}";
          Method = "GET";
          IconURL = "https://brave.com/static-assets/images/brave-favicon.png";
          Alias = "@b";
          SuggestURLTemplate =
            "https://search.brave.com/api/suggest?q={searchTerms}";
        }
        {
          Name = "SearXNG RHSCZ";
          URLTemplate = "https://search.rhscz.eu/?q={searchTerms}";
          Alias = "@s";
          Method = "GET";
          SuggestURLTemplate =
            "https://search.rhscz.eu/api/suggest?q={searchTerms}";
        }
        {
          Name = "Nixpkgs";
          URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
          Method = "GET";
          IconURL = "https://search.nixos.org/favicon.png";
          Alias = "@pkgs";
          Description = "NixOS Packages";
        }
        {
          Name = "Nixopts";
          URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
          Method = "GET";
          IconURL = "https://search.nixos.org/favicon.png";
          Alias = "@opts";
          Description = "NixOS Options";
        }
      ];
      Default = "Brave Search";
      Remove = [ "Amazon.com" "Bing" "DuckDuckGo" "eBay" "Wikipedia (en)" ];
    };
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFirefoxAccounts = true;
    DisableAccounts = true;
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisableMasterPasswordCreation = true;
    DisableProfileImport = true;
    DisableSetDesktopBackground = true;
    DisableTelemetry = true;
    DisplayBookmarksToolbar = "never";
    DontCheckDefaultBrowser = true;
    ExtensionSettings = {
      "*".installation_mode = "blocked";
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager";
        default_area = "navbar";
        install_warning = false;
        welcome = false;
      };

      "uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin";
        allowed_in_private_browsing = true;
        install_warning = false;
        default_area = "navbar";
      };

      "{84601290-bec9-494a-b11c-1baa897a9683}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/ctrl-number-to-switch-tabs";
        allowed_in_private_browsing = true;
        install_warning = false;
        default_area = "unified-extensions-area";
      };

      "sponsorBlocker@ajay.app" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock";
        install_warning = false;
        default_area = "unified-extensions-area";
      };
    };

    FirefoxHome = {
      Highlights = false;
      Locked = true;
      Pocket = false;
      Search = true;
      Snippets = false;
      SponsoredTopSites = false;
      SponsoredPocket = false;
      TopSites = false;
    };

    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    # OfferToSaveLoginsDefault = false;
    BackgroundAppUpdate = false;
    PasswordManagerEnabled = false;
    PromptForDownloadLocation = true;
    SanitizeOnShutdown = { FormData = true; };
    SearchSuggestEnabled = false;
    ShowHomeButton = false;
    SkipTermsOfUse = true;
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };
  };
}
