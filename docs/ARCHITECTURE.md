# Architecture

Before:

```text
Client -> LiteSpeed -> PHP -> WordPress -> XML-RPC -> security/application handling
```

After:

```text
Client -> LiteSpeed -> /xmlrpc.php -> 403
                                      STOP
```

The project uses a cPanel userdata include so the rule is applied to cPanel virtual hosts while keeping the configuration outside generated per-vhost files.

The rule does not disable ModSecurity or Imunify360.
