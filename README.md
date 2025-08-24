# 🔐 SSH Setup Toolkit

This repository contains three scripts designed to streamline the setup of SSH key-based authentication between a client machine and a host/server. Whether you're provisioning a new VM, configuring remote access, or onboarding a teammate, these scripts make the process repeatable, secure, and foolproof.

## 📁 Contents

| File                  | Description                                                        |
|-----------------------|--------------------------------------------------------------------|
| `ssh_client_setup.sh` | Bash script for Linux/macOS clients to generate and transfer SSH keys |
| `ssh_client_setup.ps1`| PowerShell script for Windows clients to do the same              |
| `ssh_host_setup.sh`   | Bash script for host/server to install the transferred public key |

## 🧭 Usage Guide

### 🖥️ Step 1: Run on the Client Machine

Choose the appropriate script based on your operating system:

- **Linux/macOS**  
  ```bash
  bash ssh_client_setup.sh

- **Windows (PowerShell)**

   ```powershell
   .\ssh_client_setup.ps1

## 🔧 This Will:

- Check for required SSH tools (`ssh`, `scp`, `ssh-keygen`)
- Generate a new SSH key pair (if one doesn’t exist)
- Prompt for remote username and host IP
- Transfer the public key to the host as `temp_key.pub`

---

## 🗄️ Step 2: Run on the Host Machine

- **After the public key has been transferred, log into the host and run:**

    ```bash
    bash ssh_host_setup.sh

## 🔧 This Will:

- Ensure the `.ssh` directory exists with correct permissions  
- Append the transferred public key to `~/.ssh/authorized_keys`  
- Clean up the temporary key file  

---

## 🛡️ Best Practices

- Never share your private key (`id_rsa`)  
- Use unique keys per client for traceability  
- Set proper permissions: `.ssh` → `700`, `authorized_keys` → `600`  
- Consider using passphrases for keys stored on laptops or shared devices  

---

## 🧠 Future Enhancements

This repo is designed to be modular and extensible. Future additions may include:

- Logging setup actions  
- Dry-run mode for safe testing  
- Multi-host provisioning support  
- Windows host-side setup script  

---

## 📌 Author

**Michael Brown**  
Operator mindset. Builder of resilient, scalable systems.  
Documented for clarity. Designed for continuity.