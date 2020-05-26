# Certificats Digitals

### Claus privades RSA (Ni idea de la diferència)
$ openssl genrsa -des3 -out ca.key 2048
$ openssl genrsa -nodes -out server.key 2048


# HTTPS

### Generar el certificat + clau privada autosignats

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
Enter PEM pass phrase: ​ serverkey
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



















.
