//
//  Word_AES.m
//  180125LoginTest
//
//  Created by Enrf_macmini on 2018/1/31.
//  Copyright © 2018年 Enrf_macmini. All rights reserved.
//

#import "Word_AES.h"

@implementation Word_AES

//加密
+(NSString*)encryptAESData:(NSString*)string
{
    NSString *KEY = @"!@#$YEeP%R5NQ8p*" , *Iv = @"&WHsJOMBelrGRI~?";
    
    //將nsstring轉化為nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //使用密碼對nsdata進行加密
    
    NSData *encryptedData = [self AES128EncryptWithKey:KEY gIv:Iv withNSData:data];
    
    
    //返回進行base64轉換的加密字串
    return [self encodeBase64Data:encryptedData];
}

//解密
+(NSString*)decryptAESData:(NSString *)string
{
    NSString *KEY = @"!@#$YEeP%R5NQ8p*" , *Iv = @"&WHsJOMBelrGRI~?";
    
    //base64解密
    NSData *decodeBase64Data= [self decodeBase64Data:string];
    
    //使用密碼對data進行解密
    NSData *decryData = [self AES128DecryptWithKey:KEY gIv:Iv withNSData:decodeBase64Data];
    
    //將解密的nsdata轉化為nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    
    return str;
}


//AES加密
+(NSData *)AES128EncryptWithKey:(NSString *)key gIv:(NSString *)iv withNSData:(NSData *)data
{
    char keyPtr[kCCKeySizeAES128+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    
    bzero(ivPtr, sizeof(ivPtr));
    
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    
    int newSize = 0;
    
    if(diff > 0)
    {
        newSize = (int)(dataLength + diff);
    }
    char dataPtr[newSize];
    
    memcpy(dataPtr, [data bytes], [data length]);
    
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x00, //No padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    
    if(cryptStatus == kCCSuccess)
    {
        //        NSData *data =[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    return nil;
}


//AES解密
+ (NSData *)AES128DecryptWithKey:(NSString *)key gIv:(NSString *)iv withNSData:(NSData *)data
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x00, //No padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if(cryptStatus == kCCSuccess)
    {
        //        NSData *data =[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        // NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    return nil;
}


//EncodeBase64
+(NSString*)encodeBase64Data:(NSData*)plainData{
    
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSLog(@"base64String : %@ " , base64String);
    
    return base64String;
}

//DecodeBase64
+(NSData*)decodeBase64Data:(NSString*)base64String{
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    
    //NSLog(@"decodedData : %@ " , decodedData);
    
    return decodedData;
}

@end
