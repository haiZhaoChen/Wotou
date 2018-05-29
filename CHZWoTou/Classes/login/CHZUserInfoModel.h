//
//  CHZUserInfoModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

/*address = "";
 detail = "";
 email = "";
 "head_pic" = "/public/uploads/images/";
 nickname = "\U6635\U79f0";
 qq = 123456;
 "qr_code" = "/public/uploads/images/";
 tel = 123699544;
 website = "www.ceshi.com";
 wechat = 623985;
 "end_time" = "2017\U5e7412\U670830\U65e5";
 "head_pic" = "/public/uploads/images/20170218/e5cb1e02abdd92276d54368965160062.jpg";
 nickname = tt;
 paymoney = 1;

 */

@interface CHZUserInfoModel : NSObject<NSCoding>
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *head_pic;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *qq;
@property (nonatomic, copy)NSString *qr_code;
@property (nonatomic, copy)NSString *tel;
@property (nonatomic, copy)NSString *website;
@property (nonatomic, copy)NSString *wechat;
@property (nonatomic, copy)NSString *background;
@property (nonatomic, copy)NSString *end_time;
@property (nonatomic, copy)NSString *paymoney;


+ (instancetype)userInfoWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
