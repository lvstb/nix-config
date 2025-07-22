# os.nix
# DEPRECATED: This file has been split into modular services
# Most functionality has been moved to:
# - system/core-services.nix (essential services)
# - system/desktop-services.nix (desktop environment)
# - system/nix-settings.nix (Nix daemon settings)
# 
# This file can be removed after confirming all configurations work correctly
{
  lib,
  pkgs,
  ...
}: {
  # This file is now mostly empty - services have been moved to modular files
  # Keep this comment as a migration guide
}
