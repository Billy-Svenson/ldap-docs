# set server's hostname and update the /etc/hosts file:
sudo hostnamectl set-hostname ldap.bilguun.com
echo "127.0.1.1 ldap.example.com ldap" | sudo tee -a /etc/hosts

#install OpenLDAP and utilities
sudo apt update
sudo apt install slapd ldap-utils -y

#Reconfigure slapd
sudo dpkg-reconfigure slapd
# Omit OpenLDAP server configuration? → No
# DNS domain name: bilguun.com
# Organization name: bilguun Inc.
# Administrator password: "123456"
# Remove database when slapd is purged? → No
# Move old database? → Yes

# Configure LDAP client
sudo nano /etc/ldap/ldap.conf
# edit file with your info
# BASE    dc=bilguun,dc=com
# URI     ldap://ldap.bilguun.com

# Create base directory structure
sudo nano /etc/ldap/base.ldif

# dn: ou=People,dc=bilguun,dc=com
# objectClass: organizationalUnit
# ou: People

# dn: ou=Groups,dc=bilguun,dc=com
# objectClass: organizationalUnit
# ou: Groups

# Apply configuration 
ldapadd -x -D cn=admin,dc=bilguun,dc=com -W -f base.ldif

# Add a group
sudo nano /etc/ldap/group.ldif
"dn: cn=developers,ou=Groups,dc=bilguun,dc=com
objectClass: posixGroup
cn: developers
gidNumber: 5000"

# Add the group
ldapadd -x -D cn=admin,dc=bilguun,dc=com -W -f group.ldif

# Add a user
slappasswd
New password: 0000
Re-enter new password: 0000
{SSHA}TXuTaHhJ0PHX3l5zkUC1AqS6Hth0XaYh

# create a file named user.ldif
sudo nano /etc/ldap/user.ldif

dn: uid=jbilguun,ou=People,dc=bilguun,dc=com 
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: jbilguun 
sn: Jargalsaikhan 
givenName: Bilguun 
cn: Bilguun Jargalsaikhan 
displayName: Bilguun J 
uidNumber: 10000
gidNumber: 5000
userPassword: {SSHA}TXuTaHhJ0PHX3l5zkUC1AqS6Hth0XaYh 
gecos: Bilguun Jargalsaikhan 
loginShell: /bin/bash
homeDirectory: /home/jbilguun

# add the user
ldapadd -x -D cn=admin,dc=bilguun,dc=com -W -f user.ldif
#Enter LDAP Password: 123456
# adding new entry "uid=jbilguun,ou=People,dc=bilguun,dc=com "

# Verify entries
ldapsearch -x -LLL -b dc=bilguun,dc=com uid=jbilguun

# Install LDAP account manager (optional)
sudo apt install ldap-account-manager -y


# Installation of phpLDAPadmin
sudo apt update

# Install Apache, PHP, and phpLDAPadmin
sudo apt install apache2 php libapache2-mod-php phpldapadmin -y

# Configure phpLDAPadmin
# look for "$servers->setValue('server','host','127.0.0.1');" and replace it with your ubuntu machine ip address
# Hide warnings
# look for "$config->custom->appearance['hide_template_warning'] = false;" and replace it with "$config->custom->appearance['hide_template_warning'] = true;"

# Edit Apache config for phpLDAPadmin
sudo nano /etc/apache2/conf-available/phpldapadmin.conf

# add following block at the end if it is not there
<Directory /usr/share/phpldapadmin/>
    Options FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
# This allows access from any IP

# Enable the config
sudo a2enconf phpldapadmin

# Restart Apache
sudo systemctl restart apache2

# Go to your browser and use your "ubuntu ip"/phpldapadmin
# use your credentials to log in as admin or user you created
