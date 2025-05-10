{
  homebrew = {
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    enable = true;
    casks = [
      "mac-mouse-fix"
      "ghostty"
      "signal"
      "figma"
      "firefox"
      "zen-browser"
      "brave-browser"
      "affinity-designer"
      "affinity-photo"
      "obs"

      "prismlauncher"
    ];
  };
}
