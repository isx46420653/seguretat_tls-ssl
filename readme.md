# Certificats Digitals

Claus al directori HTTPS

# Generar el certificat + clau privada autosignats

$ openssl req -new -x509 -nodes -out autosigned.server.crt -keyout autosigned.server.key

```
[Pau@portatil tmp]$ openssl req -new -x509 -nodes -out autosigned.server.crt -keyout autosigned.server.key
Generating a 2048 bit RSA private key
....................+++++
..........................+++++
writing new private key to 'autosigned.server.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:ca
State or Province Name (full name) []:Barcelona
Locality Name (eg, city) [Default City]:Barcelona
Organization Name (eg, company) [Default Company Ltd]:escola del treball de barcelona
Organizational Unit Name (eg, section) []:departament informatica
Common Name (eg, your name or your server's hostname) []:www.edt.org
Email Address []:admin@edt.org
```

# Afegir ​passfrase a la clau privada (generem un nou fitxer de clau privada)

$ openssl rsa -des3 -in autosigned.server.key -out autosigned.passfrase.server.key
```
writing RSA key
*Enter PEM pass phrase: ​ serverkey
Verifying - Enter PEM pass phrase: ​ serverkey
```

Diferències entre les claus:

$ cat autosigned.server.key
```
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDLGMq48Yh+kSBs
E96HeOxth6yy3NoodoDKQAtsZrd4njmrMm5ghlmeejAxos5gJ9iM/E6AswlnMOHD
HmVsUZqtE0O//Dku4Er/QU9pAKBopkChtHkql5ueg5nY6AiRStHK3mxzwODGk5s2
```
$ cat autosigned.passfrase.server.key
```
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,ED206733F1B365D8
```

# Crear una entitat CA pròpia (Certificate Authority)

### Generar la clau privada, encriptada amb 3des i amb passfrase (format PEM)

$ openssl genrsa -des3 -out ca.key 1024
```
Generating RSA private key, 1024 bit long modulus
...........++++++
..........................++++++
e is 65537 (0x10001)
Enter pass phrase for ca.key: ​ cakey
Verifying - Enter pass phrase for ca.key: ​ cakey
```

### Generar el certificat x509 pròpi de l'entitat CA (per a 365 dies) en format PEM

$ openssl req -new -x509 -nodes -sha1 -days 365 -key ca.key -out ca.crt
```
Enter pass phrase for ca.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:ca
State or Province Name (full name) []:Barcelona
Locality Name (eg, city) [Default City]:Barcelona
Organization Name (eg, company) [Default Company Ltd]:Veritat Absoluta
Organizational Unit Name (eg, section) []:Departament de certificats
Common Name (eg, your name or your server's hostname) []:Veritat Absoluta
Email Address []:admin@edt.org
```

### Mostrar el contingut físic de la clau
$ cat ca.key
```
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,770703FF70C7B96F
```

### Mostrar el contingut lògic de la clau
$ openssl rsa -noout -text -in ca.key
```
Enter pass phrase for ca.key:
Private-Key: (1024 bit)
modulus:
00:de:1c:ec:6c:2e:bf:4d:b6:ca:8d:93
```

### Mostrar el contingut físic del certificat x509
$ cat ca.crt
```
-----BEGIN CERTIFICATE-----
MIIDKjCCApOgAwIBAgIJANWdpn/8oUijMA0GCSqGSIb3DQEBBQUAMIGtMQswCQYD
... output suprimit ...
7zBltLVl0unEnCIxY0jNhWkLdwPz/CKuDCIl6c8XAVCfJRHMhWpi8EGUi4GW2A==
-----END CERTIFICATE-----
```

### Mostrar el contingut lògic del certificat x509
$ openssl x509 -noout -text -in ca.crt
```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            d9:b2:7d:a9:4e:d3:4c:6a
    Signature Algorithm: sha1WithRSAEncryption
        Issuer: C = ca, ST = Barcelona, L = Barcelona, O = Veritat Absoluta, OU = Departament de certificats, CN = Veritat Absoluta, emailAddress = admin@edt.org
        Validity
            Not Before: May 25 16:54:26 2020 GMT
            Not After : May 25 16:54:26 2021 GMT
        Subject: C = ca, ST = Barcelona, L = Barcelona, O = Veritat Absoluta, OU = Departament de certificats, CN = Veritat Absoluta, emailAddress = admin@edt.org
```

# Crear el certificat del servidor (real)

### Crear una clau privada per al servidor, és en format PEM, de 1024 bits i xifrada en 3DES. Utilitza passfrase

$ openssl genrsa -des3 -out server.key 1024
```
Generating RSA private key, 1024 bit long modulus
...................+++++
.......................+++++
e is 65537 (0x010001)
Enter pass phrase for server.key:
Verifying - Enter pass phrase for server.key:
```

### Generar una petició de certificat request per enviar a l'entitat certificadora CA

$ openssl req -new -key server.key -out server.csr
```
Enter pass phrase for server.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:ca
State or Province Name (full name) []:Barcelona
Locality Name (eg, city) [Default City]:Barcelona
Organization Name (eg, company) [Default Company Ltd]:escola del treball de barcelona
Organizational Unit Name (eg, section) []:departament informatica
Common Name (eg, your name or your server's hostname) []:www.edt.org
Email Address []:admin@edt.org

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:request password
An optional company name []:edt
```

### Observar la petició de certificat
$ openssl req -noout -text -in server.csr
```
[Pau@portatil https]$ openssl req -noout -text -in server.csr
Certificate Request:
    Data:
        Version: 1 (0x0)
        Subject: C = ca, ST = Barcelona, L = Barcelona, O = escola del treball de barcelona, OU = departament informatica, CN = www.edt.org, emailAddress = admin@edt.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (1024 bit)
                .......
```

### Cal crear el fitxer ca.conf, indica que certifiquen
```
basicConstraints = critical,CA:FALSE
extendedKeyUsage = ​ serverAuth​ ,emailProtection
```

# L'autoritat CA ha de signar el certificat
$ openssl x509 -CA ca.crt -CAkey ca.key -req -in server.csr -days 365 -sha1 -extfile ca.conf -CAcreateserial -out server.crt
```
Signature ok
subject=C = ca, ST = Barcelona, L = Barcelona, O = escola del treball de barcelona, OU = departament informatica, CN = www.edt.org, emailAddress = admin@edt.org
Getting CA Private Key
Enter pass phrase for ca.key: cakey
```

### Mostrar el no de sèrie que genera la CA per a cada certificat que emet.
$ cat ca.srl
```
FA5040FBF24BB30B
```

# L'entitat li enviarà al client el certificat generat: server.crt

# El client que ha sol·licitat el certificat pot validar el certificat respecte la seva clau privada
$ openssl x509 -noout -modulus -in server.crt | openssl md5
```
(stdin)= 8234d1e997bb75579106326f170cf90d
```
$ openssl rsa -noout -modulus -in server.key | openssl md5
```
Enter pass phrase for server.key: serverkey
(stdin)= 8234d1e997bb75579106326f170cf90d
```

# Afegir ​ passfrase ​ a la clau privada (generem un nou fitxer de clau privada)
$ openssl rsa -des3 -in server.key -out passfrase.server.key
```
Enter pass phrase for server.key:
writing RSA key
Enter PEM pass phrase: serverkey
Verifying - Enter PEM pass phrase: serverkey
```

# Modificar la passfrase existent

$ openssl rsa -des3 -in passfrase.server.key -out passfrase.new.server.key
```
Enter pass phrase for passfrase.server.key: serverkey
writing RSA key
Enter PEM pass phrase: newserverkey
Verifying - Enter PEM pass phrase: newserverkey
```

# Eliminar la passfrase d'una clau privada

$ openssl rsa -in passfrase.server.key -out deleted-passfrase.server.key
```
$ openssl rsa -in passfrase.server.key -out deleted-passfrase.server.key
Enter pass phrase for passfrase.server.key: serverkey
writing RSA key
```

# Verificar que el certificat i la clau-privada són conjuntats, es corresponen

$ openssl x509 -noout -modulus -in autosigned.server.crt | openssl md5
```
(stdin)= 5621dca87daf2eea88cba6e0be7779c7
```
$ openssl rsa -noout -modulus -in autosigned.server.key | openssl md5
```
(stdin)= 5621dca87daf2eea88cba6e0be7779c7
```

# LDAP

# Seguretat

### Generar claus privades del servidor

$ openssl genrsa -out cakey.pem 2048
```
Generating RSA private key, 2048 bit long modulus
.......................+++++
......................................................+++++
e is 65537 (0x010001)
```
$ openssl genrsa -out serverldapkey.pem 2048
```
Generating RSA private key, 2048 bit long modulus
....+++++
........+++++
e is 65537 (0x010001)
```

### Generar el certificat x509 pròpi de l'entitat CA (per a 365 dies) en format PEM

$ openssl req -new -x509 -nodes -sha1 -days 365 -key cakey.pem -out cacert.pem
```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:ca
State or Province Name (full name) []:Barcelona
Locality Name (eg, city) [Default City]:Barcelona
Organization Name (eg, company) [Default Company Ltd]:Veritat Absoluta
Organizational Unit Name (eg, section) []:Informatica
Common Name (eg, your name or your server's hostname) []:www.edt.org
Email Address []:admin@edt.org
```

### Generar un Request per a enviar

$ openssl req -new -key serverldapkey.pem -out serverldapcsr.pem
```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:ca
State or Province Name (full name) []:Barcelona
Locality Name (eg, city) [Default City]:Cerdanyola
Organization Name (eg, company) [Default Company Ltd]:Casa del Pau
Organizational Unit Name (eg, section) []:Dep de la meva habitacio
Common Name (eg, your name or your server's hostname) []:ldap.edt.org
Email Address []:admin@edt.org

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:request password
An optional company name []:edt
```

### CA firmant el certificat (Utilitzem el fitxer ca.conf)

$ openssl x509 -CA cacert.pem -CAkey cakey.pem -req -in serverldapcsr.pem -days 365 -sha1 -extfile ca.conf -CAcreateserial -out serverldapcrt.pem
```
Signature ok
subject=C = ca, ST = Barcelona, L = Cerdanyola, O = Casa del Pau, OU = Dep de la meva habitacio, CN = ldap.edt.org, emailAddress = admin@edt.org
Getting CA Private Key
```

### Configuració

[ldap.conf](ldap/ldap.conf)

[slapd-tls.conf](ldap/slapd-tls.conf)

[startup.sh](ldap/startup.sh)

[install.sh](ldap/install.sh)

### Docker

Imatge: **isx46420653/ldapserver:tls**

```
# Port 636 --> ldap_ssl

docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389 -p 636:636 -d isx46420653/ldapserver:tls
```

### Comprovem

\# cat /etc/hosts
```
  ...
172.17.0.2	ldap.edt.org ldap
```
\# ldapsearch -x -LLL -ZZ -b 'dc=edt,dc=org' -h ldap.edt.org dn | head -n2
```
dn: dc=edt,dc=org
```
\# openssl s_client -connect ldap.edt.org:636
```
CONNECTED(00000003)
depth=1 C = ca, ST = Barcelona, L = Barcelona, O = Veritat Absoluta, OU = Informatica, CN = www.edt.org, emailAddress = admin@edt.org
verify error:num=19:self signed certificate in certificate chain
---
Certificate chain
 0 s:/C=ca/ST=Barcelona/L=Cerdanyola/O=Casa del Pau/OU=Dep de la meva habitacio/CN=ldap.edt.org/emailAddress=admin@edt.org
   i:/C=ca/ST=Barcelona/L=Barcelona/O=Veritat Absoluta/OU=Informatica/CN=www.edt.org/emailAddress=admin@edt.org
 1 s:/C=ca/ST=Barcelona/L=Barcelona/O=Veritat Absoluta/OU=Informatica/CN=www.edt.org/emailAddress=admin@edt.org
   i:/C=ca/ST=Barcelona/L=Barcelona/O=Veritat Absoluta/OU=Informatica/CN=www.edt.org/emailAddress=admin@edt.org
---
Server certificate
-----BEGIN CERTIFICATE-----
MIID8zCCAtugAwIBAgIJAObxKHt2e9wJMA0GCSqGSIb3DQEBBQUAMIGaMQswCQYD
VQQGEwJjYTESMBAGA1UECAwJQmFyY2Vsb25hMRIwEAYDVQQHDAlCYXJjZWxvbmEx
GTAXBgNVBAoMEFZlcml0YXQgQWJzb2x1dGExFDASBgNVBAsMC0luZm9ybWF0aWNh
MRQwEgYDVQQDDAt3d3cuZWR0Lm9yZzEcMBoGCSqGSIb3DQEJARYNYWRtaW5AZWR0
Lm9yZzAeFw0yMDA1MjgxNzMyMTZaFw0yMTA1MjgxNzMyMTZaMIGlMQswCQYDVQQG
EwJjYTESMBAGA1UECAwJQmFyY2Vsb25hMRMwEQYDVQQHDApDZXJkYW55b2xhMRUw
EwYDVQQKDAxDYXNhIGRlbCBQYXUxITAfBgNVBAsMGERlcCBkZSBsYSBtZXZhIGhh
Yml0YWNpbzEVMBMGA1UEAwwMbGRhcC5lZHQub3JnMRwwGgYJKoZIhvcNAQkBFg1h
ZG1pbkBlZHQub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnCJ3
G2VCSuQWFoPL+NodAMy1qbDSJKVyPwBrGASRacRjMQw8lgV+uptBsU+4RHao3oQr
MKHLESL9/SDgGLIl1w1x13CaxYplcxegtDy12A3xmTAJw2V9Y0cJ9ShnXPRVjlUX
TIc2lxa2Ca1FlFjIvQDrOMA8eNJA7sPWa4b3A5EZuQXrrscZ35uJTZYmOrkfoK6O
Rti/0hJYwPD9jOg/m0vVOOXWKCwZUwDECYMIv9l6SfuRg8xxAObTWyU4GUwtmQks
CFuwD2se3XgKxzPMAwmn99BdPs2tgRTIYeWvMosUjqZg9oHoXsDFx4wC3Ocm//SQ
Hqtny7NlllfCVvxJ3QIDAQABoy8wLTAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQG
CCsGAQUFBwMBBggrBgEFBQcDBDANBgkqhkiG9w0BAQUFAAOCAQEAn88cM4hveMCs
uVeu15AAs9RMEQmP78h1Z4IF2H6lDwRlaiKIrbhBTld+uzWOgcrj0Md6D4jplbHq
/yU38qx/NVyXOTt7SH9TMAeg4jz2+19RCDXQwWwNamfFLVjHIF2xS15Mo9faPwBa
+Xt+VaHCQx6GV1+z2TZB3I2rXVszB4XzjAM4mtHyWUYlm5k2MDCTTkRgzkcokVf2
Jl8UDH1kZ1Tm2/b/2Q6NTxpk/Z0+BWJoyDVzHIkLCYGUkL1VzxNl9Z+AxjneEusZ
6131BYozNz9XhXGp51f1VI0bNMbJIM3/8aWnO1U0DTA8q5VtpPOC8oX/+9EFBN2K
1fe2R9J9jg==
-----END CERTIFICATE-----
subject=/C=ca/ST=Barcelona/L=Cerdanyola/O=Casa del Pau/OU=Dep de la meva habitacio/CN=ldap.edt.org/emailAddress=admin@edt.org
issuer=/C=ca/ST=Barcelona/L=Barcelona/O=Veritat Absoluta/OU=Informatica/CN=www.edt.org/emailAddress=admin@edt.org
---
