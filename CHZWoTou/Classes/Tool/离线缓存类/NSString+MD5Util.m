//
//  NSString+MD5Util.m
//  EasyPay
//
//  Created by 刘欣 on 15/5/7.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import "NSString+MD5Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Util)

- (NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];

    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call

    unsigned char reresult[16];
    CC_MD5(result, (CC_LONG)strlen((const char *)result), reresult);
   
    NSMutableString *mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [mstr appendFormat:@"%02x", result[i]];
    
    return mstr;
}

@end
