# LiteSpeed cPanel XML-RPC Blocker

A simple server-wide solution for blocking WordPress `/xmlrpc.php` requests on cPanel + LiteSpeed Enterprise servers.

## What it does

Installs this LiteSpeed rewrite rule through a cPanel userdata include:

```apache
<IfModule LiteSpeed>
    RewriteRule ^/xmlrpc\.php$ - [F,L]
</IfModule>
```

Requests to `/xmlrpc.php` return **HTTP 403** before WordPress/PHP processes the request.

## Requirements

- Root access
- cPanel/WHM
- LiteSpeed Enterprise
- `/usr/local/cpanel/scripts/rebuildhttpdconf`
- `/scripts/ensure_vhost_includes`

Tested with LiteSpeed Enterprise 6.3.7 and cPanel Apache 2.4.68.

## Install

```bash
chmod +x install.sh
./install.sh
```

The installed file is:

```text
/etc/apache2/conf.d/userdata/block-xmlrpc.conf
```

## Test

```bash
curl -k -s -o /dev/null -w '%{http_code}\n' \\
  -X POST https://example.com/xmlrpc.php \\
  -H 'Content-Type: text/xml' \\
  --data '<?xml version="1.0"?><methodCall><methodName>system.listMethods</methodName><params></params></methodCall>'
```

Expected:

```text
403
```

## Uninstall

```bash
chmod +x uninstall.sh
./uninstall.sh
```

## Important

This is a **server-wide** block for cPanel virtual hosts covered by the userdata include. It can break Jetpack, remote publishing, WordPress mobile/remote clients, or other integrations that require XML-RPC. Use a per-vhost/per-account rule if some customers require XML-RPC.

Do not disable ModSecurity or Imunify360 globally to solve XML-RPC traffic. This project only adds a LiteSpeed rewrite-level block.

## Active audit-log cleanup

If an active ModSecurity audit log is consuming disk space, use `truncate` rather than deleting the active file:

```bash
truncate -s 0 /var/log/apache2/modsec_audit.log
```

Only do this when you intentionally want to discard the existing audit log.

## Credit

Created and maintained by **Sajibe Kanti**.

© 2026 Sajibe Kanti
