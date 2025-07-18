#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Starting Ultimate Nuclei Automation...${NC}"

read -p "Enter domain (e.g., example.com): " domain
if [[ -z "$domain" ]]; then
  echo "❌ Domain required"
  exit 1
fi

folder="nuclei-scan-$domain-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$folder"
cd "$folder" || exit

# Update templates
echo -e "${YELLOW}📦 Updating Nuclei Templates...${NC}"
nuclei -update-templates

# Resolve subdomains
echo -e "${YELLOW}🌐 Enumerating subdomains...${NC}"
subfinder -d "$domain" -silent > subs.txt
cat subs.txt | httpx -silent -timeout 5 > live.txt

echo -e "${YELLOW}📌 Found $(wc -l < live.txt) live subdomains.${NC}"

# Scan with all templates
echo -e "${GREEN}🔍 Running Nuclei scan (Full throttle)...${NC}"
nuclei -l live.txt \
  -c 50 \
  -rl 150 \
  -ni \
  -s critical,high,medium \
  -severity critical,high,medium \
  -t "$HOME/nuclei-templates" \
  -tags cve,exposures,takeover,default-login,misconfiguration,token,files,technologies \
  -headless \
  -o nuclei_all_results.txt

# Optional: Run ALL templates (very heavy)
read -p "Do you want to run ALL templates (includes fuzzing, dos, headless, etc)? [y/N]: " allrun
if [[ "$allrun" == "y" || "$allrun" == "Y" ]]; then
  echo -e "${RED}⚠️ Running ALL templates... this may take a long time...${NC}"
  nuclei -l live.txt -c 50 -rl 150 -ni -severity info,low,medium,high,critical \
    -t "$HOME/nuclei-templates" \
    -o full_nuclei_blast.txt
fi

echo -e "${GREEN}✅ Scan complete! Check the folder: $folder${NC}"
