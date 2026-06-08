# MultiBatch
Multibatch is script written in batch primarily used for pentesting

---

## Features :

### 1. IP Puller (tshark)
- Retrieves your public IP automatically
- Detects tshark (Wireshark) installation, prompts to download if missing
- Lists available network interfaces
- Captures IPs via STUN packet sniffing (UDP traffic), filtering out your own IP

---

### 2. IP Toolkit
A sub-menu with tools for both public and local IPs:

- **Geolocate** — queries `ipinfo.io` to display IP, hostname, ISP, city, region, country, postal code, coordinates, and timezone
- **Trace DNS** — resolves a domain name from an IP using `nslookup`
- **Port Scan** — scans specified ports on a target IP using `PortScanner.exe`
- **DDoS** — opens links to external stress-testing services
- **Trace MAC Address** — retrieves the MAC address of a local IP via ARP
- **ARP Spoof (DoS)** — runs `arpspoof.exe` against a target local IP
- **RPC Dump** — runs `rpcdump` on a target IP to enumerate RPC services

---

### 3. Bruteforce (Network Share)
- Takes a target IP, username, and password wordlist
- Attempts authentication via `net use` (SMB/Windows file shares)
- Reports each attempt and stops on success

---

### 4. PsExec (Remote Access)
- Connects to a remote Windows machine with credentials
- Auto-configures WinRM on the target if not already enabled
- Sub-features once connected:
  - **Shell** — opens a remote `cmd` shell via `winrs`
  - **Files** — opens the remote `C$` share in Explorer
  - **Information** — runs an info-gathering script on the target
  - **Shutdown** — forces an immediate remote shutdown
  - **Disconnect** — closes the network session

---

### 5. User Bruteforce (Local)
- Lists local user accounts (name, SID, status) via `wmic`
- Bruteforces a local user account's password using `net use` against `127.0.0.1`
- Validates that the target user exists before attempting
- Reports each attempt and stops on success
