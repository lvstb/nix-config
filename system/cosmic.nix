{lib, ...}: {
  services.displayManager = {
    gdm.enable = lib.mkForce false;
    cosmic-greeter.enable = true;
    defaultSession = lib.mkForce "cosmic";
  };

  services.desktopManager = {
    gnome.enable = lib.mkForce false;
    cosmic.enable = true;
  };

  services.system76-scheduler.enable = true;
}
