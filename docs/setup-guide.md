# Setup Guide for MikroTik Hotspot Voucher

This guide explains how to set up a MikroTik CHR hotspot with Windows 7 clients in VirtualBox. These settings are for creating and testing WiFi voucher authentication in a simple internal network.

---

## 1. VirtualBox VM Setup

### MikroTik CHR VM
1. Create a new VirtualBox VM and attach the `chr-7.20.8.vdi` disk.

   Download the disk image: [chr-7.20.8.vdi.zip](https://download.mikrotik.com/routeros/7.20.8/chr-7.20.8.vdi.zip)
2. Add 4 network adapters:
   - **Adapter 1 (NAT)**: Provides internet to MikroTik (DHCP client)
   - **Adapter 2 (Host-Only)**: For stable Winbox management (Host IP: 192.168.56.1/24)
   - **Adapter 3 (Bridge)**: Optional, allows access to the physical network
   - **Adapter 4 (Internal Network)**: For hotspot clients (IP 192.168.10.1/24)

### Windows 7 VM
1. Create another VM with Windows 7.
2. Attach 4 network adapters with the same setup as MikroTik.
3. Use **Adapter 4 (Internal Network)** to connect to the hotspot network.

---

## 2. MikroTik Interface Configuration

1. Open **Winbox** and connect to MikroTik via Host-Only adapter (192.168.56.1).
2. Verify interfaces:
```
ether1 → NAT (internet)
ether2 → Host-Only (Winbox)
ether3 → Bridge
ether4 → Internal Network (Hotspot)
```

---

## 3. Internal Network & DHCP

1. Assign IP to ether4:
```
IP → Addresses → +
Address: 192.168.10.1/24
Interface: ether4
```

2. Set up a DHCP server for ether4:
```
IP → DHCP Server → DHCP Setup → select ether4
Pool: 192.168.10.2-192.168.10.254
Gateway: 192.168.10.1
DNS: 8.8.8.8
```

---

## 4. NAT Configuration

1. Enable NAT so clients can access the internet:
```
IP → Firewall → NAT → +
Chain: srcnat
Out Interface: ether1
Action: masquerade
```

---

## 5. Hotspot Setup

1. Go to **IP → Hotspot → Hotspot Setup**.
2. Select **ether4** as the hotspot interface.
3. Follow the wizard:
- Local Address of Network: 192.168.10.1
- Address Pool: 192.168.10.2-192.168.10.254
- DNS Servers: 8.8.8.8
- Hotspot Name: `hotspot`
- Create initial user (e.g., `admin` / `password`)

---

## 6. Custom Login Page (Optional)

1. Prepare your custom login page files:
```
hotspot/html/login.html
hotspot/html/login.css
hotspot/html/login.js
```

2. Upload the `html` folder to MikroTik via **Files → hotspot**.
3. Set **HTML Directory** in Hotspot Server Profile to use this folder.

---

## 7. Testing

1. On Windows 7, open any browser and access a website (e.g., `http://google.com`).
2. You should be redirected to the hotspot login page.
3. Enter your hotspot credentials to access the internet.

---

## 8. Creating Voucher Users

1. Go to **IP → Hotspot → Users → +**.
2. Add new users:
```
User: voucher1
Password: 123
```

Clients can now login using these voucher accounts.