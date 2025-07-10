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

  # Zram for better memory management
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # SSD optimizations
  services.fstrim.enable = true;
  
  # CPU governor for laptops
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  
  # Better I/O scheduler for SSDs
  boot.kernelParams = [
    "elevator=mq-deadline"
  ];
}