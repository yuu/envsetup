{ pkgs, user, ... }:
let
  # pkgs/<name>/package.nix を全部拾う
  myPkgs = pkgs.lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./pkgs;
  };

  # GUI アプリ (homebrew.casks)
  # ブラウザ
  # "responsively"
  # エディタ/AI
  # "claude"
  # appEditor   = [ "opencode-desktop" ];
  # データ
  # appData     = [ "smoothcsv" ];
  # デザイン
  # appDesign   = [ "affinity-designer" "figma" "gyazo" ];
  # 3D/CAD
  # appCad      = [ "freecad" ];
  # 動画/配信
  # appMedia    = [ "libndi" "ndi-tools" ];

  # 周辺機器
  # appDevice   = [ "logi-options+" ];
  # クラウドストレージ
  appCloud    = [ "google-drive" ];
in
{
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = user.username;
  users.users.${user.username}.home = "/Users/${user.username}";

    # terminal-notifier
  environment.systemPackages = with pkgs; [
    tmux fzf reattach-to-user-namespace
    coreutils gnutar gnugrep
    git git-lfs ghq peco
    htop jq jnv pv ripgrep fd dust unar lv nkf mas
    imagemagick ffmpeg sshpass fswatch graphviz pandoc
    yazi zoxide mediainfo exiftool mpv sox
    nmap navi qpdf arp-scan timg
    gnuradio yt-dlp zbar bandwhich
    sleek
    cloudflared
    _7zz aria2 assimp automake btop clamav cmigemo delta diff-pdf docker-compose figlet
    ghostscript gnuplot hexyl libass libgit2 libpq llama-cpp llmfit lnav matcha mermaid-cli
    mise mosh mtr mvfst ncdu ntfy paperkey pass pinact pkgconf podman postgresql putty
    qemu qrtool rdap rename rsync rtorrent sbcl sc-im socat syncthing
    treemd unixodbc w3m wakeonlan wget wrk xleak zip zstd zsh-autosuggestions
    zsh-completions
    (tesseract.override { enableLanguages = [ "eng" "jpn" "jpn_vert" ]; })
    _1password-cli _1password-gui aerospace blender cloudflare-warp discord emacs firefox
    google-chrome inkscape kitty monitorcontrol qcad slack
    tinycast vlc-bin vscode wezterm wireshark poppler-utils
  ] ++ builtins.attrValues (removeAttrs myPkgs [
    "bettertouchtool"   # pkg は残すがインストールしない
  ]);

  fonts.packages = with pkgs; [
    source-code-pro
    source-han-code-jp
    nerd-fonts.hack
    noto-fonts-cjk-sans
    hackgen-nf-font
    monaspace
    moralerspace
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = true;
      cleanup    = "none";
    };
    taps = [
      "1password/tap"
    ];
    brews = [
      # nixpkgs の mole は別物 (davrodpin/mole、SSH トンネル) で darwin 非対応。
      # 必要になったら手動で brew install する
      # "mole"
    ];
    # casks = appEditor ++ appData ++ appDesign ++ appCad ++
    #         appMedia ++ appDevice ++
    #         appCloud ++ appGame;
  };

  services.tailscale.enable = true;

  # 実機への配置が必要な自作パッケージ (activation / launchd)
  imports = [
    ./pkgs/azookey/module.nix
    ./pkgs/google-japanese-ime/module.nix
    ./pkgs/karabiner-elements/module.nix
  ];

  system.defaults = {
    NSGlobalDomain = {
      AppleShowScrollBars              = "WhenScrolling";
      AppleScrollerPagingBehavior      = true;
      KeyRepeat                        = 2;
      InitialKeyRepeat                 = 15;
      "com.apple.keyboard.fnState"     = true;
      "com.apple.trackpad.scaling"     = 3.0;
      "com.apple.swipescrolldirection" = false;
    };
    screencapture.disable-shadow = true;
    dock.mru-spaces              = false;
  };

  system.stateVersion = 5;
}
