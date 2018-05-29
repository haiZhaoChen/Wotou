//
//  Util.h
//  LocalCache
//
//  Created by tan on 13-2-6.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *)sha1:(NSString *)str;
+ (NSString *)md5Hash:(NSString *)str;
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr;

//时间戳
+(NSString*) timeStamp;

//用具体时间去生成时间戳
+(NSString*) timeStamp:(NSString*)date;

//时间戳转换成日期
+(NSDate*) timeStampToDate:(NSString*)tempStamp;

+(NSString*) createReqString:(NSArray*)reqArray AndNeedMd5:(BOOL)isNeed AndMd5Key:(NSString*)md5Key;

//分享
- (void)noneUIShareButtonAction;
//生成图片
+ (UIImage*)createImageWithColor:(UIColor*)color;

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;

#pragma 严格身份证号验证
+(BOOL)verifyIDCardNumber:(NSString*)value;
#pragma makr - 检测是否为邮箱地址
+ (BOOL)validateEmail:(NSString *)emailString;
@end
