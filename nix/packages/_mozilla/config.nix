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
      Remove =
        [ "Google" "Amazon.com" "Bing" "DuckDuckGo" "eBay" "Wikipedia (en)" ];
    };
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisableMasterPasswordCreation = true;
    DisableProfileImport = true;
    DisableSetDesktopBackground = true;
    DisableTelemetry = true;
    DisplayBookmarksToolbar = "never";
    DontCheckDefaultBrowser = true;
    ExtensionSettings = {
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager";
        install_warning = false;
      };

      "uBlock0@raymondhill.net" = {
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin";
        installation_mode = "force_installed";
        allowed_in_private_browsing = true;
        install_warning = false;
      };

      "{84601290-bec9-494a-b11c-1baa897a9683}" = {
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/ctrl-number-to-switch-tabs";
        installation_mode = "force_installed";
        allowed_in_private_browsing = true;
        install_warning = false;
      };

      # "{74145f27-f039-47ce-a470-a662b129930a}" = {
      #   install_url =
      #     "https://addons.mozilla.org/firefox/downloads/latest/clearurls";
      #   installation_mode = "force_installed";
      #   install_warning = false;
      # };

      "sponsorBlocker@ajay.app" = {
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock";
        installation_mode = "force_installed";
        install_warning = false;
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
