#!/bin/bash

echo "🔍 Zone Transfer Checker"
read -p "Enter the domain to check: " domain

if [[ -z "$domain" ]]; then
  echo "❌ Domain cannot be empty."
  exit 1
fi

echo "🌐 Getting nameservers for $domain..."
ns_list=$(dig ns "$domain" +short)

if [[ -z "$ns_list" ]]; then
  echo "❌ No nameservers found for $domain"
  exit 1
fi

echo "-----------------------------------------"
for ns in $ns_list; do
  ip=$(dig +short "$ns")
  echo "[*] Trying $ns ($ip)..."
  echo "-----------------------------------------"
  dig axfr @"$ip" "$domain" | tee /tmp/"$ns"_zone.txt
  echo "-----------------------------------------"
done

echo "✅ Done. If any AXFR succeeded, check /tmp/ns*_zone.txt for full zone data."
