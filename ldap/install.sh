#!/bin/bash
# Install ldapserver
rm -rf /etc/openldap/slapd.d/*
rm -rf /var/lib/ldap/*
cp /opt/docker/DB_CONFIG /var/lib/ldap/.
slaptest -f /opt/docker/slapd-tls.conf -F /etc/openldap/slapd.d/
slapadd -F /etc/openldap/slapd.d/ -l /opt/docker/edt.org.ldif
chown -R ldap.ldap /etc/openldap/slapd.d/
chown -R ldap.ldap /var/lib/ldap/
cp /opt/docker/ldap.conf /etc/openldap/.

# Claus & Certificats
cp /opt/docker/cacert.pem /etc/openldap/certs/.
cp /opt/docker/serverldapcrt.pem /etc/openldap/certs/.
cp /opt/docker/serverldapkey.pem /etc/openldap/certs/.
