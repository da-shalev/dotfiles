{
  homebrew = {
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    enable = true;
    casks = [
      "ghostty"
      "signal"
      "figma"
      "firefox"
      "brave-browser"
      "affinity-designer"
      "affinity-photo"
      "obs"
    ];
  };
}
