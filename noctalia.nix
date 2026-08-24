{ inputs, ...}:
{
  imports = [ inputs.noctalia.nixosModules.default inputs.noctalia-greeter.nixosModules.default ];
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true; # needed services for noctalia to function
  };

  programs.noctalia-greeter = {
    enable = false;
  };

  nix.settings = { # adding cache for noctalia so it doesn't build all the time
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
}
