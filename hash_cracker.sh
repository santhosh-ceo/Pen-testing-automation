#!/bin/bash

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🔐 Automated Hash Cracker"

# Ask for hash input
read -p "Enter the hash to crack: " hash

if [[ -z "$hash" ]]; then
  echo "❌ Hash cannot be empty."
  exit 1
fi

# Generate unique filename
timestamp=$(date +%s)
hashfile="input_hash#$timestamp.txt"
echo "$hash" > "$hashfile"
echo "📁 Hash saved to: $hashfile"

# Detect hash type using hashid
echo "🔍 Detecting hash type using hashid..."
hash_types=$(hashid -m "$hash" | grep -Eo '^\[[0-9]+\] .*' | awk -F'] ' '{print $2}' | head -n 3)

echo "📌 Detected hash types:"
echo "$hash_types"

# Map hashid type to John format (basic mapping)
function detect_john_format() {
    for type in $hash_types; do
        case "$type" in
            *MD5*) echo "raw-md5"; return ;;
            *SHA-1*) echo "raw-sha1"; return ;;
            *SHA-256*) echo "raw-sha256"; return ;;
            *SHA-512*) echo "raw-sha512"; return ;;
            *NTLM*) echo "nt"; return ;;
            *bcrypt*) echo "bcrypt"; return ;;
            *DES*) echo "des"; return ;;
            *MySQL*) echo "mysql"; return ;;
            *SHA1\ Cisco*) echo "cisco"; return ;;
        esac
    done
    echo ""
}

john_format=$(detect_john_format)

if [[ -z "$john_format" ]]; then
  echo "❌ Could not detect a compatible John format."
  exit 1
fi

echo "🧠 Using John format: $john_format"

# Crack the hash using john
echo "🚀 Cracking hash with John (rockyou.txt)..."
john --format="$john_format" --wordlist=/usr/share/wordlists/rockyou.txt "$hashfile"

# Show the cracked password
echo "🟢 Cracked Hash:"
john --show --format="$john_format" "$hashfile" | grep -v ":" && echo -e "${GREEN}✓ Password found!${NC}" || echo "❌ Not cracked."

