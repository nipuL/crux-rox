#!/bin/sh

groupadd zeroinst
useradd -g zeroinst -d /var/cache/0install.net -m zeroinst

cat > /usr/bin/0store-helper << EOF
#!/bin/sh
cd "$2" || exit 1
chmod -R a+rX .
exec sudo -u zeroinst /usr/bin/0store-helper-priv "$1"
EOF

cat > /usr/bin/0store-helper-priv << EOF
exec 0store add "$1" .
EOF

chmod a+x /usr/bin/0store-helper{,-priv}

cat << EOF
Use visudo to add the following to /etc/sudoers:

Cmnd_Alias      ZEROINSTALL = /usr/bin/0store-helper-priv
Defaults>zeroinst env_reset
ALL     ALL=(zeroinst) NOPASSWD: ZEROINSTALL
EOF
