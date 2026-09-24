{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

import ../../lib/mk-dmg-app.nix { inherit lib stdenvNoCC fetchurl _7zz; } rec {
  pname = "proton-drive";
  version = "3.0.3";
  url = "https://proton.me/download/drive/macos/${version}/ProtonDrive-${version}.dmg";
  hash = "sha256-6JxGdjKpGBXV7azhCRf42xmnEtfETbzA2/FnsnTmOVE=";
  app = "Proton Drive.app";

  meta = {
    description = "Proton Drive client";
    homepage = "https://proton.me/drive";
    license = lib.licenses.unfree;
  };
}
