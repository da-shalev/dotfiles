lockPref("dom.disable_beforeunload", true);
lockPref("browser.tabs.unloadOnLowMemory", false);
lockPref("layout.css.devPixelsPerPx", "1.25");
lockPref("browser.startup.homepage_override.mstone", "ignore");
lockPref("browser.warnOnQuitShortcut", false);
lockPref("browser.tabs.groups.smart.enabled", false);
lockPref("browser.aboutConfig.showWarning", false);
lockPref("general.autoScroll", true);
lockPref("browser.urlbar.showSearchHistory", false);
lockPref("browser.urlbar.suggest.history", false);
lockPref("browser.theme.native-theme", false);
lockPref("browser.theme.toolbar-theme", 2);
lockPref("devtools.toolbox.host", "right");
lockPref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
lockPref("svg.context-properties.content.enabled", true);
lockPref("browser.discovery.enabled", false);
lockPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
lockPref("browser.newtabpage.activity-stream.telemetry", false);
lockPref("app.shield.optoutstudies.enabled", false);
lockPref("breakpad.reportURL", "");
lockPref("browser.tabs.crashReporting.sendReport", false);
lockPref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
lockPref("browser.crashReports.unsubmittedCheck.enabled", false);

// I dont need
lockPref("browser.urlbar.addons.featureGate", false);
lockPref("browser.urlbar.fakespot.featureGate", false);
lockPref("browser.urlbar.mdn.featureGate", false);
lockPref("browser.urlbar.pocket.featureGate", false);
lockPref("browser.urlbar.weather.featureGate", false);
lockPref("browser.urlbar.yelp.featureGate", false);
lockPref("media.webspeech.synth.enabled", false);

// faster, is better
lockPref("network.prefetch-next", true);
lockPref("network.predictor.enabled", true);
lockPref("network.predictor.enable-prefetch", true);
lockPref("browser.cache.disk.enable", true);
lockPref("media.hardware-video-decoding.force-enabled", true);

// restore history
lockPref("browser.startup.page", 3);

// I do not like side tabs
lockPref("sidebar.revamp", false);

// curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/nightly/scripts/install-by-curl.sh | bash
lockPref("gnomeTheme.oledBlack", true);
lockPref("gnomeTheme.hideSingleTab", true);

// about:blank homepage
lockPref("browser.startup.homepage", "about:blank");
lockPref("browser.newtabpage.enabled", false);
