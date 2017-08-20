#!/bin/bash

CONF="/etc/ssmtp/ssmtp.conf"
: ${SMTP_HOST:="smtp.example.host"}
: ${SMTP_USER:="relay@smtp.example.host"}
: ${SMTP_PASS:='kjsdlfjkp3j4oijlrjngkrbg'}
: ${SMTP_PORT:='587'}
: ${SMTP_SECURE:='TRUE'}
: ${SMTP_TLS:='TRUE'}
: ${SMTP_MASQ:='example.host'}

SMTP_SECURE=$(echo $SMTP_SECURE | tr '[A-Z]' '[a-z]')
SMTP_TLS=$(echo $SMTP_TLS | tr '[A-Z]' '[a-z]')

cat > $CONF <<EOF
MailHub=$SMTP_HOST:$SMTP_PORT
FromLineOverride=YES
Hostname=$SMTP_MASQ
RewriteDomain=$SMTP_MASQ
AuthUser=$SMTP_USER
AuthPass=$SMTP_PASS
TLS_CA_Dir=/usr/share/ca-certificates
EOF

if [ $SMTP_SECURE == "true" ]
 then
	echo "UseTLS=Yes" >> $CONF
 else
	echo "UseTLS=No" >> $CONF
fi

if [ $SMTP_SECURE == "true" -a $SMTP_TLS = "true" ]
 then
	echo "UseSTARTTLS=Yes" >> $CONF
 else
	echo "UseSTARTTLS=No" >> $CONF
fi
