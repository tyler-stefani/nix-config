{ pkgs, traits, ... }:
{
  imports = with traits; [
    editor
    git
    prompt
    shell
    styling
  ];

  home = {
    username = "tyler";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/tyler" else "/home/tyler";
  };

  home.stateVersion = "24.11";
}
