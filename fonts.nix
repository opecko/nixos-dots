{ config, pkgs, ... }:

{

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMonoNL Nerd Font" ];
  };
}
