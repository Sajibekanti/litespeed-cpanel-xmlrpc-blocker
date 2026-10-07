#!/bin/bash
# LiteSpeed cPanel XML-RPC Blocker - Uninstaller
# Credit: Sajibe Kanti
set -euo pipefail
INCLUDE_FILE="/etc/apache2/conf.d/userdata/block-xmlrpc.conf"
if [[ $EUID -ne 0 ]]; then echo "ERROR: Run as root."; exit 1; fi
if [[ -f "$INCLUDE_FILE" ]]; then rm -f "$INCLUDE_FILE"; echo "Removed $INCLUDE_FILE"; else echo "Include not found."; fi
/usr/local/cpanel/scripts/rebuildhttpdconf
/scripts/ensure_vhost_includes --all-users
apachectl -t
systemctl restart lsws
echo "XML-RPC blocker removed."
