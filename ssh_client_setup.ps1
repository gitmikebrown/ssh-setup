<#
.SYNOPSIS
    Sets up SSH key-based authentication from a Windows client to a remote host.

.DESCRIPTION
    Checks for OpenSSH tools, generates an RSA key pair if missing, and transfers the public key.
    Designed for repeatable use on Windows 10/11 with OpenSSH installed.

.AUTHOR
    Michael Brown
#>

function Test-Command($cmd) {
    $exists = Get-Command $cmd -ErrorAction SilentlyContinue
    if (-not $exists) {
        Write-Host "❌ '$cmd' is not available. Please install OpenSSH Client from Windows Features." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`nChecking for required tools..." -ForegroundColor Cyan
Test-Command ssh
Test-Command scp
Test-Command ssh-keygen

Write-Host "`nAll required tools are available." -ForegroundColor Green

$sshPath = "$env:USERPROFILE\.ssh"
$privateKey = "$sshPath\id_rsa"
$publicKey  = "$sshPath\id_rsa.pub"

# Ensure .ssh directory exists
if (-not (Test-Path $sshPath)) {
    New-Item -ItemType Directory -Path $sshPath -Force | Out-Null
    Write-Host "Created .ssh directory at $sshPath"
}

# Generate SSH key if missing
if (-not (Test-Path $privateKey)) {
    Write-Host "`nGenerating new SSH key..." -ForegroundColor Cyan
    ssh-keygen -t rsa -b 4096 -f $privateKey -N ""
    Write-Host "SSH key generated at $privateKey"
} else {
    Write-Host "SSH key already exists at $privateKey. Skipping generation." -ForegroundColor Yellow
}

# Prompt for remote host info
Write-Host "`nTransferring public key to remote host..." -ForegroundColor Cyan
$remoteUser = Read-Host "Enter remote username"
$remoteHost = Read-Host "Enter remote host IP or domain"

# Transfer public key
try {
    scp $publicKey "${remoteUser}@${remoteHost}:~/temp_key.pub"
    Write-Host "Public key transferred to $remoteHost as temp_key.pub"
    Write-Host "Now run ssh_host_setup.sh on the remote host to complete setup." -ForegroundColor Cyan
} catch {
    Write-Host "Failed to transfer public key. Check network, credentials, or SSH access." -ForegroundColor Red
}