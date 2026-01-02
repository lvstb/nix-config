# Performance optimizations
{ lib, pkgs, ... }: {
  # Kernel optimizations
  boot.kernel.sysctl = {
    # Network performance
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.ipv4.tcp_rmem" = "4096 87380 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    
    # Memory management
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    
    # File system performance
    "fs.file-max" = 2097152;
  };

  # Zram disabled due to hardware incompatibility
  # zramSwap = {
  #   enable = true;
  #   algorithm = "zstd";
  #   memoryPercent = 50;
  # };

  # SSD optimizations
  services.fstrim.enable = true;

  # CPU governor - performance for desktop use
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # AMD P-State for Zen 4 CPUs (Ryzen 7 8845HS)
  boot.kernelParams = [
    "amd_pstate=active"
    "amd_pstate.shared_mem=1"
  ];
}