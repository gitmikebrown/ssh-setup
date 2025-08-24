#!/bin/bash
# File: 
# Author: Michael Brown
# Date: 
# Description: 


sudo nano /etc/ssh/sshd_config
#OR
sudo cat /etc/ssh/sshd_config

################################################################################################
####   Restart
################################################################################################
#Change port 22 to something else
#   Done as port 22 is well known


################################################################################################
####   Change "AddressFamily any" to "AddressFamily inet"
################################################################################################
#
#   valid arguments for this option:
#
#       any: Use both IPv4 and IPv6 (default).
#       inet: Use IPv4 only.
#       inet6: Use IPv6 only

################################################################################################
####   Change "PermitRootLogin yes" to no
################################################################################################
#
#   The PermitRootLogin option in the OpenSSH configuration file (sshd_config) controls whether the 
#   root user can log in using SSH. Here are the possible values for this option:
#
#       yes: Allows root to log in with any authentication method.
#       prohibit-password: Allows root to log in only with public key authentication.
#       forced-commands-only: Allows root to log in with public key authentication, but only to run specific commands.
#       no: Disables root login entirely (default setting).

################################################################################################
####   Change "PasswordAuthentication yes" to no
################################################################################################
#
#   The PasswordAuthentication option in the OpenSSH configuration file (sshd_config) controls 
#   whether password-based authentication is allowed for SSH connections. Here are the possible values:
#
#       yes: Enables password authentication.
#       no: Disables password authentication (default setting for enhanced security).

#restart the service
sudo systemctl restart sshd
