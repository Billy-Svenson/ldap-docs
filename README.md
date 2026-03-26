ldap-docs
Step-by-step setup guide for OpenLDAP on Ubuntu — from bare installation to a working directory with users, groups, and a web UI. Written as annotated shell commands with actual outputs included.
What it covers

Installing and configuring slapd (OpenLDAP server) on Ubuntu
Setting up the base directory structure — People and Groups organizational units
Creating users and groups with posixAccount schema
Generating password hashes with slappasswd
Configuring the LDAP client (ldap.conf)
Installing and accessing phpLDAPadmin web UI via Apache
Installing LDAP Account Manager as an alternative UI

Stack
ComponentRoleslapdOpenLDAP server daemonldap-utilsCLI tools (ldapadd, ldapsearch, etc)phpldapadminWeb UI for browsing and managing the directoryldap-account-managerAlternative web UIApache + PHPWeb server for phpLDAPadmin
Domain used in examples
Domain:   bilguun.com
Base DN:  dc=bilguun,dc=com
Admin:    cn=admin,dc=bilguun,dc=com
Replace with your own domain throughout.
Structure created
dc=bilguun,dc=com
├── ou=People
│   └── uid=jbilguun (Bilguun Jargalsaikhan)
└── ou=Groups
    └── cn=developers (gidNumber: 5000)
Notes

Admin password in examples is intentionally weak (123456) — use a strong password in any real environment
phpLDAPadmin config requires updating the server host IP to match your machine
Apache config needs the Require all granted block to allow external access to phpLDAPadmin
This is a learning/reference document, not a hardened production setup
