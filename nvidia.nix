# -=- nvidia grafika -=-
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    # GeForce 920MX
    branch = "legacy_580";
    open = false;

    # Wayland / Hyprland
    modesetting.enable = true;
    nvidiaSettings = true;
    
    # we do NOT want to power off GPU
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # PRIME sync
    prime = {
      sync.enable = true;
      
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:3:0:0";
    
    };

  };

  environment.systemPackages = with pkgs; [
    
    egl-wayland
  ];

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";

  };

}
