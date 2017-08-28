#!/bin/bash
# @file
# @brief This script generates the necessary entries in /etc/hosts and a dnsmasq.conf style configuration file
# @see http://praxis.edoceo.com/howto/samba4
# @see http://en.gentoo-wiki.com/wiki/Samba4_as_Active_Directory_Server
# @see http://samba.2283325.n4.nabble.com/Samba-4-home-folder-td4121303.html
# @see http://samba.2283325.n4.nabble.com/The-quot-homes-quot-folder-in-Samba4-td4362833.html
# @see http://lists.samba.org/archive/samba/2010-January/152913.html
# @see http://lists.samba.org/archive/samba/2010-October/158629.html
# @see http://technet.microsoft.com/en-us/library/cc961719.aspx
# @see http://lists.samba.org/archive/samba-technical/2010-December/075465.html

echo <<EOH
Usage: $0"
--hosts to make hosts file
--dnsmasq to make /etc/dnsmasq.conf update
--domain=
--nt4dom=
--pdc=
EOH

PDC="EDIT_ME"
IP4="EDIT_ME"

DOMAIN="EDIT_ME"
NT4DOM="EDIT_ME"

ADHOST="${PDC}.${DOMAIN}"
ADGUID="EDIT_ME"
ADSITE="default-first-site-name"

cat <<EOD

address=/${ADGUID}._msdcs.${DOMAIN}/$IP4
# address=/${ADGUID}._msdcs.${DOMAIN}/$IP6
address=/gc._msdcs.${DOMAIN}/$IP4
# address=/gc._msdcs.${DOMAIN}/$IP6
address=/kerberos.${DOMAIN}/$IP4
# address=/kerberos.${DOMAIN}/$IP6

# Maybe Remove the Above for ADGUID?
# cname=${ADGUID}._msdcs.${DOMAIN},${ADHOST}
cname=${DOMAIN},${ADHOST}

# Global Catalog
srv-host=_gc._tcp.${DOMAIN},${ADHOST},3268
srv-host=_gc._tcp.${ADSITE}._sites.${DOMAIN},${ADHOST},3268
# gc._msdcs. DnsForestName . ?? 

# Kerberos
# This is queried for, but I don't know which port to reply with
# srv-host=_kerberos._http.${DOMAIN},${ADHOST},80
srv-host=_kerberos._tcp.${DOMAIN},${ADHOST},88
srv-host=_kerberos._tcp.dc._msdcs.${DOMAIN},${ADHOST},88
srv-host=_kerberos._tcp.${ADSITE}._sites.${DOMAIN},${ADHOST},88
srv-host=_kerberos._tcp.${ADSITE}._sites.dc._msdcs.${DOMAIN},${ADHOST},88
srv-host=_kerberos._udp.${DOMAIN},${ADHOST},88
# srv-host=_kerberos._tcp.dc._msdcs.${DNSFOREST}                ${ADHOST} 88
# srv-host=_kerberos._tcp.${ADSITE}._sites.dc._msdcs.${DNSFOREST} ${ADHOST} 88

# kpasswd
srv-host=_kpasswd._tcp.${DOMAIN},${ADHOST},464
srv-host=_kpasswd._udp.${DOMAIN},${ADHOST},464

# LDAP Server
srv-host=_ldap._tcp.${ADGUID}.domains._msdcs.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${ADSITE}._sites.dc._msdcs.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${ADSITE}._sites.${PDC}.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${ADSITE}._sites.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.dc._msdcs.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${ADSITE}._sites.dc._msdcs.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${ADSITE}._sites.gc._msdcs.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${ADSITE}._sites.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.gc._msdcs.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${PDC}._msdcs.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${PDC}.${DOMAIN},${ADHOST},389
srv-host=_ldap._tcp.${DOMAIN},${ADHOST},389
# srv-host=${DOMAIN},${ADHOST},389

## @todo figure this one out
## ; heimdal 'find realm for host' hack
# _kerberos               IN TXT  ${REALM}
# txt-record=_kerberos.${DOMAIN},"something"

# ptr-record=<name>,<target>

EOD

## krb5 servers
## MIT kpasswd likes to lookup this name on password change
# _kerberos-master._tcp           IN SRV 0 100 88         ${ADHOST}
# _kerberos-master._udp           IN SRV 0 100 88         ${ADHOST}
