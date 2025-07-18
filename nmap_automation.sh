#!/bin/bash

echo "🔎 Nmap Recon Script"
read -p "Enter the target (domain or IP): " target

if [[ -z "$target" ]]; then
  echo "❌ Target cannot be empty."
  exit 1
fi

folder="nmap-recon-$target-$(date +%Y%m%d-%H%M%S)"
mkdir "$folder"
cd "$folder" || exit

echo "📂 Output will be saved in: $folder"

# ---------- Optional: Resolve domain to IP ----------
if [[ "$target" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  ip=$(dig +short "$target" | tail -n1)
  echo "🧠 Resolved $target to $ip"
else
  ip="$target"
fi

# ---------- Fast Port Scan (Top 1000) ----------
echo "🚀 Fast Scan (Top 1000 Ports)"
nmap -Pn -T4 -sS --open "$ip" -oN fast_scan.txt

# ---------- Full TCP Port Scan (1-65535) ----------
echo "🧠 Full TCP Port Scan (1-65535)"
nmap -Pn -T4 -p- -sS --open "$ip" -oN full_port_scan.txt

# ---------- Service & Version Detection ----------
echo "🔍 Service & Version Detection"
nmap -Pn -T4 -sV -sC -p- "$ip" -oN service_scan.txt

# ---------- OS Detection ----------
echo "💻 OS Detection"
nmap -Pn -O "$ip" -oN os_detection.txt

# ---------- Vulnerability Scanning ----------
echo "🛡️ Running Vulnerability Scripts"
nmap -Pn --script vuln "$ip" -oN vuln_scan.txt

# ---------- Web-related Scripts ----------
echo "🌐 Running HTTP Enumeration Scripts"
nmap -Pn -p 80,443,8080,8443 --script http-enum,http-title,http-headers "$ip" -oN http_scan.txt

# ---------- SSL & TLS Enumeration ----------
echo "🔐 SSL/TLS Scan (if applicable)"
nmap -Pn -p 443,8443 --script ssl-cert,ssl-enum-ciphers "$ip" -oN ssl_scan.txt

# ---------- FTP, SMB, and Others ----------
echo "📁 Running Service-Specific Scripts"
nmap -Pn --script "ftp*,smb*,ssh2-enum-algos" "$ip" -p 21,22,139,445 -oN service_specific.txt

echo "✅ Nmap recon complete. All results saved in $folder"
