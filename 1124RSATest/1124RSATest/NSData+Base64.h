//
//  NSData+Base64.h
//  1124RSATest
//
//  Created by FengZhen on 15/11/24.
//  Copyright (c) 2015年 FengZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
@end
