{ pkgs, ... }:
let
  root = "${pkgs.callPackage ./package.nix { }}/root";
in
{
  # SMAppService のヘルパーは公式の場所に無いと登録されないので実体をコピーする
  system.activationScripts.postActivation.text = ''
    pq="/Library/Application Support/org.pqrs"
    stamp="$pq/.karabiner-nix-src"
    if [ "$(cat "$stamp" 2>/dev/null)" != "${root}" ]; then
      mkdir -p "$pq/tmp"
      for p in \
        "Applications/Karabiner-Elements.app" \
        "Applications/Karabiner-EventViewer.app" \
        "Applications/.Karabiner-VirtualHIDDevice-Manager.app" \
        "Library/Application Support/org.pqrs/Karabiner-Elements" \
        "Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"
      do
        rm -rf "/''${p:?}"
        /usr/bin/ditto "${root}/''${p:?}" "/''${p:?}"
        chmod -R u+w "/''${p:?}"
      done
      # 以下は公式 pkg の postinstall 相当 (アイコン切替と自己バックアップは省略)
      [ -f "$pq/tmp/karabiner_machine_identifier.json" ] || \
        echo "{\"karabiner_machine_identifier\": \"krbn-$(uuidgen | tr '[:upper:]' '[:lower:]')\"}" > "$pq/tmp/karabiner_machine_identifier.json"
      chmod 0644 "$pq/tmp/karabiner_machine_identifier.json"
      chmod 4755 "$pq/Karabiner-Elements/bin/karabiner_session_monitor"
      killall Karabiner-Core-Service karabiner_session_monitor karabiner_console_user_server \
              Karabiner-Menu Karabiner-MultitouchExtension Karabiner-NotificationWindow \
              Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || true
      echo "${root}" > "$stamp"
    fi
  '';
}
