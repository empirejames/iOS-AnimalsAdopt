//
//  Word_AES.h
//  180125LoginTest
//
//  Created by Enrf_macmini on 2018/1/31.
//  Copyright © 2018年 Enrf_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface Word_AES : NSObject

+(NSString*)encryptAESData:(NSString*)string;

+(NSString*)decryptAESData:(NSString *)string;

+(NSData *)AES128EncryptWithKey:(NSString *)key gIv:(NSString *)iv withNSData:(NSData *)dat;

+(NSData *)AES128DecryptWithKey:(NSString *)key gIv:(NSString *)iv withNSData:(NSData *)data;

+(NSString*)encodeBase64Data:(NSData*)plainData;

@end
