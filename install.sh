#!/bin/bash
# LiteSpeed cPanel XML-RPC Blocker
# Credit: Sajibe Kanti
set -euo pipefail
INCLUDE_DIR="/etc/apache2/conf.d/userdata"
INCLUDE_FILE="${INCLUDE_DIR}/block-xmlrpc.conf"
BACKUP_DIR="/root/xmlrpc-blocker-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

if [[ $EUID -ne 0 ]]; then echo "ERROR: Run as root."; exit 1; fi
for cmd in /usr/local/cpanel/scripts/rebuildhttpdconf /scripts/ensure_vhost_includes /usr/local/lsws/bin/lshttpd; do
  [[ -x "$cmd" ]] || { echo "ERROR: Required component not found: $cmd"; exit 1; }
done

echo "LiteSpeed cPanel XML-RPC Blocker - Credit: Sajibe Kanti"
echo "LiteSpeed version:"
/usr/local/lsws/bin/lshttpd -v || true

mkdir -p "$INCLUDE_DIR"
if [[ -f "$INCLUDE_FILE" ]]; then
  mkdir -p "$BACKUP_DIR"
  cp -a "$INCLUDE_FILE" "$BACKUP_DIR/block-xmlrpc.conf.${TIMESTAMP}.bak"
  echo "Existing include backed up to $BACKUP_DIR/block-xmlrpc.conf.${TIMESTAMP}.bak"
fi

cat > "$INCLUDE_FILE" <<'RULE'
# LiteSpeed cPanel XML-RPC Blocker
# Credit: Sajibe Kanti
<IfModule LiteSpeed>
    RewriteRule ^/xmlrpc\.php$ - [F,L]
</IfModule>
RULE
chmod 0644 "$INCLUDE_FILE"

/usr/local/cpanel/scripts/rebuildhttpdconf
/scripts/ensure_vhost_includes --all-users
apachectl -t
systemctl restart lsws

echo
echo "Installed: $INCLUDE_FILE"
cat "$INCLUDE_FILE"
echo
echo "Test with a hosted domain; expected HTTP status: 403"
