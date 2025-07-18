#!/bin/bash

echo "🔍 Recon Automation Script"
read -p "Enter the target domain (e.g., example.com): " domain

if [[ -z "$domain" ]]; then
  echo "❌ Domain cannot be empty."
  exit 1
fi

folder="recon-$domain-$(date +%Y%m%d-%H%M%S)"
mkdir "$folder"
cd "$folder" || exit

echo "📂 Output will be saved in: $folder"

# ---------- Subdomain Enumeration ----------

echo "🔎 Running Sublist3r..."
sublist3r -d "$domain" -o subdomain1.txt
cat subdomain1.txt | wc -l

echo "🔎 Running Subfinder..."
subfinder -d "$domain" -v -o subdomain2.txt
cat subdomain2.txt | wc -l

echo "🔎 Running Chaos..."
chaos -d "$domain" -o subdomain3.txt
cat subdomain3.txt | wc -l

# ---------- Combine & Deduplicate ----------
echo "📦 Combining all subdomains..."
cat subdomain1.txt subdomain2.txt subdomain3.txt > subfinal.txt
cat subfinal.txt | wc -l

echo "🧹 Removing duplicates..."
sort subfinal.txt | uniq > subuniq.txt
cat subuniq.txt | wc -l

# ---------- Probing Live Subdomains ----------
echo "🌐 Checking for live subdomains with httpx-toolkit..."
cat subuniq.txt | httpx-toolkit > subdomainlive.txt
cat subdomainlive.txt | wc -l

# ---------- Git Dorking ----------
echo "🕵️ Running GitDorker..."
python3 GitDorker.py -d Dorks/medium_dorks.txt -tf tf/TOKENSFILE -q "$domain" -lb

# ---------- Dirsearch ----------
echo "📂 Running dirsearch on $domain..."
dirsearch -u "https://$domain" -e php,cgi,htm,html,shtm,shtml,js,txt,bak,zip,old,conf,log,pl,asp,aspx,jsp,sql,db,sqlite,mdb,tar,gz,7z,rar,json,xml,yml,yaml,ini,java,py,rb,php3,php4,php5 \
  --random-agent --recursive -R 3 -t 20 --exclude-status 404 --follow-redirects --delay 0.1

# ---------- JavaScript Discovery ----------
echo "📜 Extracting .js files using Katana..."
katana -list subfinal.txt -jc | grep "\.js$" | uniq | sort > js.txt

# ---------- URL Collection ----------
echo "🌍 Crawling URLs with Katana..."
katana -u "$domain" -d 5 -ps -pss waybackarchive,commoncrawl,alienvault -hf -jc -fx -ef woff,css,png,svg,jpg,woff2,jpeg,gif,svg -o allurls.txt

# ---------- Sensitive Files ----------
echo "🔐 Looking for sensitive files in allurls.txt..."
cat allurls.txt | grep -Ei "\.txt|\.log|\.cache|\.secret|\.db|\.backup|\.yml|\.json|\.gz|\.rar|\.zip|\.config" > sensitive_files.txt

# ---------- JavaScript for analysis ----------
cat allurls.txt | grep -E "\.js$" >> js.txt

# ---------- Nuclei Scanning ----------
echo "🚨 Running Nuclei on allurls.txt..."
cat allurls.txt | nuclei -t ~/.local/nuclei-templates/ -severity critical,high,medium -o nuclei_results.txt

# ---------- GF Patterns ----------
echo "🕳️ Running GF for LFI and XSS..."
cat allurls.txt | gf lfi | nuclei -tags lfi -o gf_lfi_results.txt
waybackurls "https://$domain" | gf xss > gf_xss_urls.txt

echo "✅ Recon complete. All files saved in $folder"
