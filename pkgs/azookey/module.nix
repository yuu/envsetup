{ pkgs, ... }:
let
  app = "${pkgs.callPackage ./package.nix { }}/Library/Input Methods/azooKeyMac.app";
in
{
  # IME はシンボリックリンクでは認識されないので実体をコピーする
  system.activationScripts.postActivation.text = ''
    stamp="/Library/Input Methods/.azooKeyMac.app.nix-src"
    if [ "$(cat "$stamp" 2>/dev/null)" != "${app}" ]; then
      rm -rf "/Library/Input Methods/azooKeyMac.app"
      cp -R "${app}" "/Library/Input Methods/azooKeyMac.app"
      chmod -R u+w "/Library/Input Methods/azooKeyMac.app"
      echo "${app}" > "$stamp"
    fi
  '';
}
