# iOS-RSA
iOS中使用RSA加密
RSA算法是一种非对称加密算法,常被用于加密数据传输.如果配合上数字摘要算法, 也可以用于文件签名.
本文将讨论如何在iOS中使用RSA传输加密数据.

#RSA基本原理

RSA使用"秘匙对"对数据进行加密解密.在加密解密数据前,需要先生成公钥(public key)和私钥(private key).
公钥(public key): 用于加密数据. 用于公开, 一般存放在数据提供方, 例如iOS客户端.
私钥(private key): 用于解密数据. 必须保密, 私钥泄露会造成安全问题.
iOS中的Security.framework提供了对RSA算法的支持.这种方式需要对密匙对进行处理, 根据public key生成证书, 通过private key生成p12格式的密匙.
除了Secruty.framework, 也可以将openssl库编译到iOS工程中, 这可以提供更灵活的使用方式.
本文使用Security.framework的方式处理RSA.

#RSA加密中需要用到两个文件

1、含有公钥信息的.der文件
2、含有私钥信息的.p12文件
以下为生成方式(生成后导入工程即可,在终端输入以openssl开头的命令)

#!/usr/bin/env bash

echo "Generating RSA key pair ..."

echo "1024 RSA key: private_key.pem"

openssl genrsa -out private_key.pem 1024

echo "create certification require file: rsaCertReq.csr"

openssl req -new -key private_key.pem -out rsaCertReq.csr

echo "create certification using x509: rsaCert.crt"

openssl x509 -req -days 3650 -in rsaCertReq.csr -signkey private_key.pem -out rsaCert.crt

echo "create public_key.der For IOS"

openssl x509 -outform der -in rsaCert.crt -out public_key.der

echo "create private_key.p12 For IOS. Please remember your password. The password will be used in iOS."

openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt

echo "create rsa_public_key.pem For Java"

openssl rsa -in private_key.pem -out rsa_public_key.pem -pubout

echo "create pkcs8_private_key.pem For Java"

openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt

echo "finished."

#加密(使用到含有公钥信息的.der文件)

RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
[rsa loadPublicKeyFromFile:publicKeyPath];

NSString *securityText = @"Hello RSA";
NSString *encryptedString = [rsa rsaEncryptString:securityText];

#解密(使用到含有私钥信息的.p12文件)

[rsa loadPrivateKeyFromFile:[[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"] password:@"123456"];
NSString *decryptedString = [rsa rsaDecryptString:encryptedString];
