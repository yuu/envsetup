{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anydesk";
  version = "9.8.0";

  src = fetchurl {
    # ponytail: 配布 URL にバージョンが無い。AnyDesk が新版を出すと hash 不一致で落ちるので、
    # そのときは `nix store prefetch-file https://download.anydesk.com/anydesk.dmg` で hash を更新する
    url = "https://download.anydesk.com/anydesk.dmg";
    hash = "sha256-bBY3+Js0z7+7TQ0Cw/6BQorNje/OqbCsIP9l/cwEFEk=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = "AnyDesk.app";

  # 署名済みの .app 。fixupPhase に触らせない
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/AnyDesk.app"
    cp -R . "$out/Applications/AnyDesk.app"

    runHook postInstall
  '';

  meta = {
    description = "Remote desktop client";
    homepage = "https://anydesk.com/";
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
