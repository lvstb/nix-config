# NixOS Configuration

A comprehensive NixOS and Home Manager configuration designed for multi-system deployment with secure secrets management.

## 🏗️ Structure

```
nix-config/
├── config/           # Static configuration files
├── dotfiles/         # Dotfiles and configs
├── home/            # Home Manager modules
├── hosts/           # Host-specific configurations
├── modules/         # Reusable Nix modules
├── secrets/         # Encrypted secrets (sops-nix)
├── system/          # System-wide configurations
├── users/           # User-specific configurations
├── scripts/         # Helper scripts
├── .sops.yaml       # Sops configuration
└── flake.nix        # Main flake configuration
```

## 🚀 Quick Start

### Prerequisites
- NixOS installed
- Flakes enabled
- Git configured

### Deploy to Framework Laptop
```bash
# Clone the repository
git clone <repository-url>
cd nix-config

# Deploy system configuration
just deploy framework

# Deploy user configuration
just user lars
```

## 🖥️ Systems

### Current Systems
- **framework**: Framework 13 AMD laptop with GNOME desktop
- **beelink**: Beelink desktop system

### Features by System
- **Framework**: Full laptop setup with WiFi secrets, secure boot, hardware optimizations
- **Beelink**: Desktop configuration with simplified boot setup

## 🏠 Home Manager

The configuration uses Home Manager for user-specific settings:

- **Shell**: Zsh with Starship prompt
- **Editor**: Neovim with custom configuration
- **Terminal**: Ghostty
- **Development**: VSCode, Go, Node.js, Python
- **Applications**: Firefox, Thunderbird, Slack, Discord

### Key Features
- Declarative dotfiles management
- Consistent shell environment
- Development tools and language servers
- GUI applications with themes

## 🔐 Secrets Management

This configuration uses [sops-nix](https://github.com/Mic92/sops-nix) for secure secrets management.

### Setup Secrets (First Time)

1. **Generate age key** (already done for framework):
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   chmod 600 ~/.config/sops/age/keys.txt
   ```

2. **Add secrets**:
   ```bash
   # Common secrets (shared across systems)
   nix-shell -p sops --run "sops secrets/common.yaml"
   
   # Framework-specific secrets
   nix-shell -p sops --run "sops secrets/framework.yaml"
   ```

3. **Deploy with secrets**:
   ```bash
   just deploy framework
   ```

### Available Secrets
- **Common**: User info, email credentials, SSH keys, GitHub tokens
- **Framework**: WiFi passwords, hardware-specific configs

### Access Secrets
```bash
# Secrets are available at runtime
sudo cat /run/secrets/user_full_name
sudo cat /run/secrets/email_wingu_address
sudo cat /run/secrets/wifi_home_password
```

## 🔧 Development

### Available Commands
```bash
# Update flake inputs
just update

# Format Nix code
just fmt

# Deploy system
just deploy framework

# Deploy user config
just user lars

# Clean old generations
just clean

# Refresh WiFi connection with secrets
./scripts/refresh-wifi.sh
```

### Helper Scripts
- `scripts/refresh-wifi.sh` - Refreshes WiFi connection with updated secrets
- `scripts/setup-secrets.sh` - Helps configure secrets for Thunderbird and Git

### Development Tools
This configuration uses [just](https://github.com/casey/just) as a command runner for common tasks. All commands are defined in the `justfile` at the root of the repository.

## 🌐 Multi-System Support

### Adding a New System

1. **Bootstrap secrets**:
   ```bash
   ./scripts/bootstrap-secrets.sh newsystem
   ```

2. **Follow printed instructions** to update `.sops.yaml`

3. **Create host configuration**:
   ```bash
   mkdir hosts/newsystem
   # Add configuration.nix and hardware-configuration.nix
   ```

4. **Update flake.nix** to include new system

5. **Deploy**:
   ```bash
   just deploy newsystem
   ```

### macOS Support
The configuration is ready for macOS deployment using nix-darwin:
- Multi-system flake structure
- Platform-specific modules
- Shared home-manager configuration

## 📦 Key Features

### Performance Optimizations
- **Binary caches**: Cachix for faster builds
- **Parallel builds**: Multi-core compilation
- **Garbage collection**: Automatic cleanup

### Security
- **Secure Boot**: Lanzaboote integration
- **Encrypted secrets**: sops-nix with age encryption
- **Per-system keys**: Isolated secret access
- **WiFi password management**: Secure WiFi credentials via secrets

### Developer Experience
- **Secrets integration**: Git, Thunderbird, and system services use encrypted secrets
- **Modular design**: Easy to customize and extend
- **Multi-system support**: Framework laptop and Beelink desktop configurations

## 🎨 Customization

### Override Defaults
The configuration uses `lib.mkDefault` extensively, making it easy to override:

```nix
# In user configuration
programs.firefox.enable = false;  # Disable Firefox
programs.chromium.enable = true;  # Use Chromium instead
```

### Add New Modules
```nix
# In flake.nix homeModules
homeModules = [
  ./home/applications.nix
  ./home/my-custom-module.nix  # Add your module
  # ...
];
```

## 🔍 Troubleshooting

### Common Issues

**Secrets not decrypting**:
```bash
# Check age key exists
ls -la ~/.config/sops/age/keys.txt

# Verify key in .sops.yaml
age-keygen -y ~/.config/sops/age/keys.txt

# Check if secrets are available
sudo ls -la /run/secrets/
```

**WiFi not connecting with secret**:
```bash
# Refresh WiFi connection
./scripts/refresh-wifi.sh

# Or manually refresh
sudo nmcli connection delete "2Fly4MyWifi"
sudo systemctl restart NetworkManager
```

**Home Manager conflicts**:
```bash
# Remove conflicting packages
nix profile list
nix profile remove <package-name>

# Then rebuild
just user lars
```

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [sops-nix Documentation](https://github.com/Mic92/sops-nix)
- [Flake Utils](https://github.com/numtide/flake-utils)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on your system
5. Submit a pull request

## 📄 License

This configuration is provided as-is for educational purposes. Feel free to use and modify for your own systems.