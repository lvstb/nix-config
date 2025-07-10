#!/usr/bin/env bash
set -euo pipefail

SYSTEM_NAME="${1:-}"
if [[ -z "$SYSTEM_NAME" ]]; then
    echo "Usage: $0 <system-name>"
    echo "Example: $0 macbook"
    exit 1
fi

echo "🔑 Bootstrapping secrets for system: $SYSTEM_NAME"

# Generate age key if it doesn't exist
AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
if [[ ! -f "$AGE_KEY_FILE" ]]; then
    echo "📝 Generating new age key..."
    mkdir -p "$(dirname "$AGE_KEY_FILE")"
    nix-shell -p age --run "age-keygen -o $AGE_KEY_FILE"
    chmod 600 "$AGE_KEY_FILE"
fi

# Get public key
PUBLIC_KEY=$(nix-shell -p age --run "age-keygen -y $AGE_KEY_FILE")
echo "🔓 Public key: $PUBLIC_KEY"

# Save public key for reference
mkdir -p keys/public
echo "$PUBLIC_KEY" > "keys/public/$SYSTEM_NAME.pub"
echo "💾 Public key saved to keys/public/$SYSTEM_NAME.pub"

# Create encrypted backup
mkdir -p keys/backup
BACKUP_FILE="keys/backup/$SYSTEM_NAME-$(date +%Y%m%d).age"
nix-shell -p age --run "age -r $PUBLIC_KEY $AGE_KEY_FILE" > "$BACKUP_FILE"
echo "🔒 Encrypted backup created: $BACKUP_FILE"

echo ""
echo "📋 Next steps:"
echo "1. Add this key to secrets/.sops.yaml:"
echo "   - &$SYSTEM_NAME $PUBLIC_KEY"
echo ""
echo "2. Update creation_rules to include *$SYSTEM_NAME"
echo ""
echo "3. Re-encrypt secrets:"
echo "   nix-shell -p sops --run 'sops updatekeys secrets/common.yaml'"
echo "   nix-shell -p sops --run 'sops updatekeys secrets/framework.yaml'"
echo ""
echo "4. Deploy with:"
echo "   sudo nixos-rebuild switch --flake .#$SYSTEM_NAME"
echo ""
echo "5. Test secret access:"
echo "   sudo cat /run/secrets/github_token"