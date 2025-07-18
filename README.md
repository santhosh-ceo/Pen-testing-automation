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
