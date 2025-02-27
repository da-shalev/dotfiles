{ pkgs, ... }: {
  security.pki.installCACerts = false;

  fonts = { packages = with pkgs; [ nerd-fonts.caskaydia-cove lato inter ]; };
  environment = {
    shells = [ pkgs.fish ];
    systemPackages = with pkgs; [ xcodes ];
  };
  programs.fish.enable = true;

  system = {
    defaults = {
      CustomSystemPreferences = { };
      CustomUserPreferences = {
        "com.apple.WindowManager" = {
          StageManagerHideWidgets = 1;
          StandardHideWidgets = 1;
        };
      };

      # disable "Application Downloaded from Internet" popup
      LaunchServices.LSQuarantine = false;

      NSGlobalDomain = {
        # drag windows by holding CTRL + CMD
        NSWindowShouldDragOnGesture = true;

        # prevent holding a key to get diffrent accents for said key
        # very annoying if you like holding down keys
        ApplePressAndHoldEnabled = false;

        # scroll bar actually works like one, i.e. you click where you want to be
        AppleScrollerPagingBehavior = true;
        # show all file extensions
        AppleShowAllExtensions = false;
        # show hidden files and dirs
        AppleShowAllFiles = true;

        # prevent auto correction
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        # disable smart dashes
        NSAutomaticDashSubstitutionEnabled = false;

        # disable iCloud as a default storage destination
        NSDocumentSaveNewDocumentsToCloud = false;

        # expand save panel by default
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        # expand print panel by default
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        # enable natural scrolling
        "com.apple.swipescrolldirection" = true;

        # increase window resize speed for Cocoa applications
        # NSWindowResizeTime = 1.0e-3;
      };

      trackpad = {
        # tapping works yaya
        Clicking = true;
        # make trackpad haptic feedback be soft
        ActuationStrength = 0;
        FirstClickThreshold = 0;
        SecondClickThreshold = 0;
      };

      dock = {
        # hide the dock so you can actually use the monitor you paid for
        autohide = true;
        autohide-time-modifier = 0.1;
        autohide-delay = 0.0;

        # prevent automatic arrangement of spaces
        mru-spaces = false;

        # dock impermenance why not
        persistent-apps = [
          "/Applications/Brave Browser.app"
          "/Applications/Ghostty.app"
          "/System/Applications/Notes.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Messages.app/"
          "/Applications/Signal.app/"
          "/System/Applications/Music.app"
        ];

        show-process-indicators = false;
        showhidden = true;
        minimize-to-application = true;
        show-recents = false;
        tilesize = 64;
        wvous-tl-corner = 2;
        wvous-br-corner = 1;

        # Spring-loaded Dock items are supposed to save you 
        # time by allowing you to drag a file over the folder/icon. 
        # Hover it for a few seconds and the application/folder will open.
        enable-spring-load-actions-on-all-items = true;
      };

      finder = {
        CreateDesktop = true;
        FXPreferredViewStyle = "clmv";
        FXEnableExtensionChangeWarning = false;
      };

      loginwindow = { GuestEnabled = false; };
    };

    keyboard = {
      enableKeyMapping = false;
      # swapLeftCommandAndLeftAlt = false;
      #    currently remapped to globe for new WM stuff
      #    remapCapsLockToEscape = true;
    };
  };
}
