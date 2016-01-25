//
//  ViewController.m
//  1124RSATest
//
//  Created by FengZhen on 15/11/24.
//  Copyright (c) 2015年 FengZhen. All rights reserved.
//

#import "ViewController.h"
#import "RSAEncryptor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    
    //加密
    //NSLog(@"encryptor using rsa");
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    NSLog(@"public key: %@", publicKeyPath);
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString *securityText = @"hello ~";
    NSString *encryptedString = [rsa rsaEncryptString:securityText];
    NSLog(@"encrypted data: %@", encryptedString);
    
    //解密
    [rsa loadPrivateKeyFromFile:[[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"] password:@"123456"];
    NSString *decryptedString = [rsa rsaDecryptString:encryptedString];
    NSLog(@"decrypted data: %@", decryptedString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
