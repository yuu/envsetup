{ pkgs, user, ... }:
{
  home.username = user.username;
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/${user.username}"
    else "/home/${user.username}";
  home.stateVersion = "24.11";
}
