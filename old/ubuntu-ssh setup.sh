#!/bin/bash
# File: ssh_setup_guide.sh
# Author: Michael Brown
# Date: 2025-08-24
# Description: Guide for setting up SSH access via username/password or key-based authentication.

################################################################################################
#### SSH - USERNAME AND PASSWORD ACCESS
#### NOTE: Once SSH is installed and running, you can log in using any valid system user.
####       Below is how to create a custom user for SSH access.
################################################################################################

# Create a new user for SSH access
ssh_user="${USER}_ssh"
sudo adduser "$ssh_user"
sudo usermod -aG sudo "$ssh_user"

################################################################################################
#### SSH - KEY-BASED AUTHENTICATION
#### NOTE: These steps are for setting up SSH key access from a client machine to a server.
################################################################################################

### Step 1: Generate SSH Key on the Client Machine

# Linux / Ubuntu Client
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
# Leave passphrase blank for automated access, or set one for added security

# Windows PowerShell Client
ssh-keygen -t rsa -b 4096
# Keys are saved to: $env:USERPROFILE\.ssh\id_rsa and id_rsa.pub

### Step 2: Transfer Public Key to the Server

# Option A: Using ssh-copy-id (Linux client only)
ssh-copy-id username@server_ip

# Option B: Manual Transfer (Cross-platform)

# From Windows PowerShell
scp $env:USERPROFILE\.ssh\id_rsa.pub username@server_ip:~/temp_key.pub

# Then on the server (Ubuntu VM)
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cat ~/temp_key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
rm ~/temp_key.pub

### Step 3: Test SSH Connection

# From the client machine
ssh username@server_ip

### Optional: Simplify with SSH Config File (Client Side)

# Linux: ~/.ssh/config
# Windows: $env:USERPROFILE\.ssh\config

# Example entry:
Host myserver
    HostName server_ip
    User username
    IdentityFile ~/.ssh/id_rsa

# Connect using:
ssh myserver

################################################################################################
#### SSH - TROUBLESHOOTING & UTILITIES
################################################################################################

# Check open ports (SSH should be on 22)
sudo ss -tupln | grep ssh

# Get your VM's IP address
hostname -I

# Windows Hyper-V hostname format
# Example: brownmij_ssh@[VMName].mshome.net

# AWS Example (IFT560 lab)
ssh-keygen -t rsa -f ~/.ssh/id_rsa

################################################################################################
#### NOTES & BEST PRACTICES
################################################################################################

# Permissions matter:
# ~/.ssh should be 700
# ~/.ssh/authorized_keys should be 600

# Never copy private keys between machines—only transfer the .pub file

# Use unique keys per machine for better traceability

# Consider passphrases for keys stored on laptops or shared devices

# For PuTTY users:
# Convert OpenSSH key to .ppk using PuTTYgen
# Configure PuTTY to use the private key for authentication
