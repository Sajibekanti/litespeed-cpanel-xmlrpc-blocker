# Usage Guide

## Install

```bash
chmod +x install.sh uninstall.sh
./install.sh
```

## Verify

```bash
cat /etc/apache2/conf.d/userdata/block-xmlrpc.conf
```

## Test

```bash
curl -k -i -X POST https://example.com/xmlrpc.php \\
  -H 'Content-Type: text/xml' \\
  --data '<?xml version="1.0"?><methodCall><methodName>system.listMethods</methodName><params></params></methodCall>'
```

Expected: `HTTP/2 403` from LiteSpeed.

## Multiple domains

```bash
for d in example.com example.net; do
  echo -n "$d: "
  curl -k -s -o /dev/null -w '%{http_code}\n' -X POST "https://$d/xmlrpc.php" \\
    -H 'Content-Type: text/xml' \\
    --data '<?xml version="1.0"?><methodCall><methodName>system.listMethods</methodName><params></params></methodCall>'
done
```

## Uninstall

```bash
./uninstall.sh
```

## Log cleanup

For an active ModSecurity audit log:

```bash
truncate -s 0 /var/log/apache2/modsec_audit.log
```
