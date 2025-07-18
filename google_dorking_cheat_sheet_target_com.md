
# Comprehensive Google Dorking Cheat Sheet

Google dorking is a powerful technique used to find sensitive information, vulnerabilities, or interesting files indexed by Google. Below is a categorized list of common Google dork types with examples tailored for the domain `target.com`.

---

## 1. Basic Site Search

**Purpose:** Search within a specific domain.

```plaintext
site:target.com
```

---

## 2. Filetype Search

**Purpose:** Find specific file types hosted on the site.

- Find PDFs:

  ```plaintext
  site:target.com filetype:pdf
  ```

- Find Excel files:

  ```plaintext
  site:target.com filetype:xls OR filetype:xlsx
  ```

- Find Word documents:

  ```plaintext
  site:target.com filetype:doc OR filetype:docx
  ```

---

## 3. Directory Listing Exposure

**Purpose:** Find open directory listings that may expose sensitive files.

```plaintext
site:target.com intitle:"index of"
```

---

## 4. Login Pages

**Purpose:** Find login or admin pages.

```plaintext
site:target.com inurl:login
```

```plaintext
site:target.com inurl:admin
```

---

## 5. Configuration Files

**Purpose:** Locate configuration or backup files that may contain sensitive info.

- `.env` files:

  ```plaintext
  site:target.com ext:env
  ```

- `.git` directories:

  ```plaintext
  site:target.com inurl:.git
  ```

- Backup files:

  ```plaintext
  site:target.com ext:bak OR ext:old OR ext:backup
  ```

---

## 6. Sensitive Information

**Purpose:** Find exposed sensitive data like passwords, API keys, tokens.

- Password files or hints:

  ```plaintext
  site:target.com intext:"password"
  ```

- API keys:

  ```plaintext
  site:target.com intext:"api_key" OR intext:"apikey"
  ```

- Email addresses:

  ```plaintext
  site:target.com intext:"@target.com"
  ```

---

## 7. Vulnerable Files & Injection Points

**Purpose:** Identify URLs potentially vulnerable to injection or RCE.

- URLs with parameters:

  ```plaintext
  site:target.com inurl:"?id="
  ```

- URLs with `php` parameters:

  ```plaintext
  site:target.com inurl:".php?id="
  ```

- URLs indicating file download or inclusion:

  ```plaintext
  site:target.com inurl:"download.php?file="
  ```

---

## 8. Exposed Backup & Database Files

**Purpose:** Find database backups or exports.

- SQL files:

  ```plaintext
  site:target.com filetype:sql
  ```

- CSV files:

  ```plaintext
  site:target.com filetype:csv
  ```

---

## 9. Error Messages

**Purpose:** Find pages displaying detailed error messages that reveal system info.

```plaintext
site:target.com intext:"Warning" OR intext:"Error on line"
```

---

## 10. Documents Containing Sensitive Info

**Purpose:** Find documents potentially containing sensitive info like credentials or configs.

- Excel sheets with passwords:

  ```plaintext
  site:target.com intext:"password" filetype:xls
  ```

- Word docs mentioning credentials:

  ```plaintext
  site:target.com intext:"credentials" filetype:doc
  ```

---

## 11. Source Code Exposure

**Purpose:** Find exposed source code files.

```plaintext
site:target.com ext:php OR ext:js OR ext:html
```

---

## 12. Interesting URL Parameters

**Purpose:** Identify interesting parameters that might be injectable or vulnerable.

```plaintext
site:target.com inurl:"?search="
```

```plaintext
site:target.com inurl:"?page="
```

---

## 13. Find Publicly Exposed Cameras or Devices

**Purpose:** Find exposed webcams or devices.

```plaintext
inurl:"target.com/view/index.shtml"
```

```plaintext
site:target.com intitle:"Live View / - AXIS"
```

---

## 14. Google Cache and Cached Data

**Purpose:** View cached versions of pages.

```plaintext
cache:target.com
```

---

## 15. Subdomains Enumeration

**Purpose:** Find subdomains indexed by Google.

```plaintext
site:*.target.com
```

---

## 16. Custom Search Using Intext and Intitle

- Find pages with "confidential" in the title:

  ```plaintext
  site:target.com intitle:"confidential"
  ```

- Find pages mentioning "internal use only":

  ```plaintext
  site:target.com intext:"internal use only"
  ```

---

## 17. Finding Robots.txt or Sitemap.xml

- Robots.txt:

  ```plaintext
  site:target.com filetype:txt inurl:robots.txt
  ```

- Sitemap.xml:

  ```plaintext
  site:target.com filetype:xml inurl:sitemap
  ```

---

## 18. Finding Exposed Logs

**Purpose:** Find log files that might contain sensitive info.

```plaintext
site:target.com filetype:log
```

---

## 19. Finding Credentials or Keys

- Look for AWS credentials:

  ```plaintext
  site:target.com intext:"AWS_ACCESS_KEY_ID"
  ```

- Look for private keys:

  ```plaintext
  site:target.com filetype:key OR filetype:pem OR filetype:crt
  ```

---

## 20. Other Useful Operators

| Operator      | Description                          | Example                              |
|---------------|----------------------------------|------------------------------------|
| `site:`       | Limits results to domain          | `site:target.com`                   |
| `filetype:`   | Limits results to file extension  | `filetype:pdf`                     |
| `inurl:`      | Search within the URL             | `inurl:login`                      |
| `intitle:`    | Search within the page title     | `intitle:"index of"`               |
| `intext:`     | Search within page text           | `intext:"password"`                |
| `cache:`      | Show Google cached version        | `cache:target.com`                 |
| `related:`    | Find sites related to a domain    | `related:target.com`               |
| `link:`       | Find pages linking to a URL       | `link:target.com/login`            |

---

# Notes and Tips

- Combine operators to narrow down searches.
- Use quotes `""` to search exact phrases.
- Experiment with different file types and keywords related to your target.
- Always respect privacy and legality — only test authorized targets.

---

# Resources

- [Google Dorks Database (Exploit-DB)](https://www.exploit-db.com/google-hacking-database)
- [Google Operators](https://ahrefs.com/blog/google-advanced-search-operators/)
- [Google Dorking for Penetration Testing](https://portswigger.net/web-security/google-hacking)

---

# Disclaimer

This document is for educational and authorized penetration testing purposes only. Unauthorized scanning or data harvesting may be illegal.

---

*Happy Dorking! 🕵️‍♂️*
