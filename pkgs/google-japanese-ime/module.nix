{ pkgs, ... }:
let
  app = "${pkgs.callPackage ./package.nix { }}/Library/Input Methods/GoogleJapaneseInput.app";
  res = "/Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources";
in
{
  # IME はシンボリックリンクでは認識されないので実体をコピーする
  system.activationScripts.postActivation.text = ''
    stamp="/Library/Input Methods/.GoogleJapaneseInput.app.nix-src"
    if [ "$(cat "$stamp" 2>/dev/null)" != "${app}" ]; then
      rm -rf "/Library/Input Methods/GoogleJapaneseInput.app"
      cp -R "${app}" "/Library/Input Methods/GoogleJapaneseInput.app"
      chmod -R u+w "/Library/Input Methods/GoogleJapaneseInput.app"
      echo "${app}" > "$stamp"
    fi
  '';

  # 変換エンジンとレンダラ (pkg 同梱の plist と同じ内容)
  launchd.agents = {
    "com.google.inputmethod.Japanese.Converter".serviceConfig = {
      Label = "com.google.inputmethod.Japanese.Converter";
      Program = "${res}/GoogleJapaneseInputConverter.app/Contents/MacOS/GoogleJapaneseInputConverter";
      MachServices."com.google.inputmethod.Japanese.Converter.session" = true;
      KeepAlive = false;
    };
    "com.google.inputmethod.Japanese.Renderer".serviceConfig = {
      Label = "com.google.inputmethod.Japanese.Renderer";
      Program = "${res}/GoogleJapaneseInputRenderer.app/Contents/MacOS/GoogleJapaneseInputRenderer";
      MachServices."com.google.inputmethod.Japanese.Renderer.renderer" = true;
      KeepAlive = false;
    };
  };
}
