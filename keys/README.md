# Key Management

## Structure
```
keys/
├── public/           # Public keys (safe to commit)
├── private/          # Private keys (gitignored)
└── backup/          # Encrypted backups (gitignored)
```

## Usage

### Generate new system key
```bash
./scripts/bootstrap-secrets.sh newsystem
```

### Backup private keys
```bash
# Encrypt and backup to external drive
age -r $(cat keys/public/framework.pub) ~/.config/sops/age/keys.txt > keys/backup/framework-$(date +%Y%m%d).age
```

### Restore private keys
```bash
# Decrypt from backup
age -d -i ~/.config/sops/age/keys.txt keys/backup/framework-20240101.age > ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

## Security Notes
- Private keys never leave `~/.config/sops/age/`
- Always backup encrypted private keys
- Rotate keys annually
- Use hardware security keys for production systems