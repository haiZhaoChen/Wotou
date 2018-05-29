//
//  CHZUserInfoModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZUserInfoModel.h"

@implementation CHZUserInfoModel

+ (instancetype)userInfoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.address = dict[@"address"];
        self.detail = dict[@"detail"];
        self.email = [NSString stringWithFormat:@"%@",dict[@"email"]];
        if (dict[@"head_pic"] != [NSNull null]) {
            self.head_pic = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"head_pic"]];
        }else{
            self.head_pic = @"";
        }
        self.nickname = dict[@"nickname"];
        self.qq = [NSString stringWithFormat:@"%@",dict[@"qq"]];
        if (dict[@"qr_code"]!= [NSNull null]) {
            self.qr_code = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"qr_code"]];
        }else{
            self.qr_code = @"";
        }
        self.tel = [NSString stringWithFormat:@"%@",dict[@"tel"]];
        self.website = dict[@"website"];
        self.wechat = [NSString stringWithFormat:@"%@",dict[@"wechat"]];
        if (dict[@"background"] != [NSNull null]) {
            self.background = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"background"]];
        }else{
            self.background = @"";
        }
        self.paymoney = [NSString stringWithFormat:@"%@",dict[@"paymoney"]];
        self.end_time = dict[@"end_time"];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.detail = [aDecoder decodeObjectForKey:@"detail"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.head_pic = [aDecoder decodeObjectForKey:@"head_pic"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.qq = [aDecoder decodeObjectForKey:@"qq"];
        self.qr_code = [aDecoder decodeObjectForKey:@"qr_code"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
        self.website = [aDecoder decodeObjectForKey:@"website"];
        self.wechat = [aDecoder decodeObjectForKey:@"wechat"];
        self.background = [aDecoder decodeObjectForKey:@"background"];
        self.paymoney = [aDecoder decodeObjectForKey:@"paymoney"];
        self.end_time = [aDecoder decodeObjectForKey:@"end_time"];
    }
    return self;
    
    
}
/**
 * 编码
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.head_pic forKey:@"head_pic"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.qr_code forKey:@"qr_code"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeObject:self.website forKey:@"website"];
    [aCoder encodeObject:self.wechat forKey:@"wechat"];
    [aCoder encodeObject:self.background forKey:@"background"];
    [aCoder encodeObject:self.paymoney forKey:@"paymoney"];
    [aCoder encodeObject:self.end_time forKey:@"end_time"];
    
}


@end
