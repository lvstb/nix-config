# Lars' Nix Configuration

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
git clone https://github.com/yourusername/nix-config
cd nix-config

# Deploy system configuration
sudo nixos-rebuild switch --flake .#framework

# Deploy user configuration
just user lars
```

## 🖥️ Systems

### Current Systems
- **framework**: Framework 13 AMD laptop with GNOME desktop

### Planned Systems
- **macbook**: Apple Silicon macOS (ready for deployment)

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
   sudo nixos-rebuild switch --flake .#framework
   ```

### Available Secrets
- **Common**: GitHub tokens, SSH keys, API keys
- **Framework**: WiFi passwords, VPN configs, work credentials

### Access Secrets
```bash
# Secrets are available at runtime
sudo cat /run/secrets/github_token
sudo cat /run/secrets/wifi_password
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

# Show system differences
just diff

# Clean old generations
just clean
```

### Development Shell
```bash
# Enter development environment
nix develop

# Available tools: nixd, alejandra, just
```

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
   sudo nixos-rebuild switch --flake .#newsystem
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

### Developer Experience
- **Flake-utils**: Multi-system support
- **lib.mkDefault**: Composable configurations
- **Modular design**: Easy to customize and extend

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
```

**Build failures**:
```bash
# Check flake syntax
nix flake check

# Build with verbose output
nixos-rebuild switch --flake .#framework --show-trace
```

**Home Manager conflicts**:
```bash
# Backup conflicting files
mv ~/.config/conflicting-file ~/.config/conflicting-file.backup
home-manager switch --flake .#lars
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