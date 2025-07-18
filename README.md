# Pen-testing-automation


## Zone Transfer

#### Make it executable:

```chmod +x zone_transfer_check.sh```

#### Run it:

```./zone_transfer_check.sh```





## Recon Automation

#### Make it executable:

```chmod +x recon_automation.sh```

#### Run it:

```./recon_automation.sh```

#### Requirements

Make sure the following tools are installed :

    sublist3r

    subfinder

    chaos

    httpx-toolkit

    GitDorker.py

    dirsearch

    katana

    nuclei

    gf

    waybackurls





## NMAP Automation

#### Make it executable:

```chmod +x nmap_automation.sh```

#### Run it:

```./nmap_automation.sh```

#### Output Files

    fast_scan.txt — top 1000 ports

    full_port_scan.txt — full TCP scan

    service_scan.txt — service & version detection

    os_detection.txt — OS fingerprinting

    vuln_scan.txt — vulnerability scripts

    http_scan.txt — HTTP info

    ssl_scan.txt — SSL/TLS info

    service_specific.txt — FTP/SMB/SSH-specific scripts

#### Requirements

**Make sure:**

nmap is installed

You have permission to scan the target




## Hash Cracher

#### Requirements

    john (John the Ripper)

    hashid (install with pip install hashid)

    rockyou.txt wordlist (usually in /usr/share/wordlists/ on Kali)


#### Make it executable:

```chmod +x hash_cracker.sh```

#### Run it:

```./hash_cracker.sh```




## Auto Travelsal Scanner


#### Make executable:

```chmod +x auto_traversal_scanner.sh```

#### Run it:

```./auto_traversal_scanner.sh```

#### Required Tools:

    curl

    gau: go install github.com/lc/gau/v2/cmd/gau@latest

    waybackurls: go install github.com/tomnomnom/waybackurls@latest




## AUto SQLI Scanner

#### Tools Required:

    sqlmap: [apt install sqlmap]

    gau: go install github.com/lc/gau/v2/cmd/gau@latest

    waybackurls: go install github.com/tomnomnom/waybackurls@latest

    curl

#### How to Use:
```
chmod +x auto_sqli_scanner.sh
./auto_sqli_scanner.sh
```



## Nuclei Ultimate Scanner


#### Prerequisites
```
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
```

#### Make it executable:

```chmod +x nuclei_ultimate_scanner.sh```

#### Run:

```./nuclei_ultimate_scanner.sh```


#### Output Structure
```
nuclei-scan-example.com-20250718/
├── subs.txt                  # Resolved subdomains
├── live.txt                  # Live subdomains
├── nuclei_all_results.txt   # Main results (critical-high-medium)
├── full_nuclei_blast.txt    # (optional) Full template scan
```



