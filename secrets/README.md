# Secrets Management

This directory contains encrypted secrets managed by [sops-nix](https://github.com/Mic92/sops-nix).

## 📁 Files

- **`.sops.yaml`** - Sops configuration (in root directory)
- **`common.yaml`** - Shared secrets across all systems (encrypted)
- **`framework.yaml`** - Framework laptop specific secrets (encrypted)
- **`*.example`** - Example files showing secret structure (unencrypted)

## 🔐 Usage

### First Time Setup

1. **Generate age key** (already done for framework):
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   chmod 600 ~/.config/sops/age/keys.txt
   ```

2. **Copy example files**:
   ```bash
   cp secrets/common.yaml.example secrets/common.yaml
   cp secrets/framework.yaml.example secrets/framework.yaml
   ```

3. **Edit with your real secrets**:
   ```bash
   sops secrets/common.yaml
   sops secrets/framework.yaml
   ```

4. **Encrypt the files**:
   ```bash
   sops --encrypt --in-place secrets/common.yaml
   sops --encrypt --in-place secrets/framework.yaml
   ```

### Daily Usage

```bash
# Edit encrypted secrets
sops secrets/common.yaml
sops secrets/framework.yaml

# View decrypted content (for debugging)
sops --decrypt secrets/common.yaml

# Re-encrypt after adding new keys to .sops.yaml
sops updatekeys secrets/common.yaml
sops updatekeys secrets/framework.yaml
```

## 🏗️ Secret Categories

### Common Secrets (`common.yaml`)
- **Development**: GitHub tokens, SSH keys, API keys
- **Cloud**: AWS, GCP, Azure credentials
- **Databases**: PostgreSQL, Redis connection strings
- **Email**: SMTP credentials
- **Monitoring**: Grafana, Prometheus credentials
- **Certificates**: SSL certificates and private keys

### Framework Secrets (`framework.yaml`)
- **Network**: WiFi passwords, VPN configurations
- **Work**: Corporate credentials, LDAP passwords
- **Development**: Local database passwords, Docker registry
- **Personal**: Bitwarden, Nextcloud, email accounts
- **Hardware**: BIOS passwords, LUKS recovery keys
- **Backup**: Restic passwords, remote backup credentials
- **Smart Home**: Home Assistant, MQTT credentials

## 🔑 Key Management

### Current Keys
- **Framework laptop**: `age176e8uyk9wdhszj8qghksmz73vfu0pwdcw9p4pg65l4e05v56s4lqr7eukm`

### Adding New Systems

1. **Generate key on new system**:
   ```bash
   ./scripts/bootstrap-secrets.sh newsystem
   ```

2. **Add public key to `.sops.yaml`**:
   ```yaml
   keys:
     - &framework age176e8uyk9wdhszj8qghksmz73vfu0pwdcw9p4pg65l4e05v56s4lqr7eukm
     - &newsystem age1newkeyhere...
   ```

3. **Update creation rules**:
   ```yaml
   creation_rules:
     - path_regex: secrets/common\.yaml$
       key_groups:
         - age:
             - *framework
             - *newsystem
   ```

4. **Re-encrypt secrets**:
   ```bash
   sops updatekeys secrets/common.yaml
   ```

## 🛡️ Security Best Practices

### ✅ Do
- Keep private keys secure (`~/.config/sops/age/keys.txt`)
- Use unique keys per system
- Backup your age keys securely
- Use descriptive secret names
- Organize secrets by category
- Rotate secrets regularly

### ❌ Don't
- Share private keys between systems
- Commit unencrypted secrets
- Use weak passwords
- Store secrets in comments
- Leave example files with real data

## 🔍 Troubleshooting

### "sops metadata not found"
```bash
# File wasn't encrypted properly
sops --encrypt --in-place secrets/yourfile.yaml
```

### "failed to parse input as Bech32-encoded age public key"
```bash
# Invalid key in .sops.yaml - check key format
age-keygen -y ~/.config/sops/age/keys.txt
```

### "config file not found"
```bash
# .sops.yaml must be in project root
ls -la .sops.yaml
```

### Secrets not accessible in NixOS
```bash
# Check secret paths
sudo ls -la /run/secrets/
sudo cat /run/secrets/github_token
```

## 📚 Resources

- [sops-nix Documentation](https://github.com/Mic92/sops-nix)
- [SOPS Documentation](https://github.com/mozilla/sops)
- [Age Encryption](https://github.com/FiloSottile/age)