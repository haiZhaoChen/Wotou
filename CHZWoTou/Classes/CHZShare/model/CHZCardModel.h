//
//  CHZCardModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZCardModel : NSObject
/*
 {
 "head_pic" = "20170208/794d6b7eacc206af4124b2dcacbc6973.jpg";
 id = 3;
 nickname = Cheney;
 "qr_code" = "20170208/1d6d5b7118817b002f260538a2a73166.jpg";
 tel = 546565668;
 uid = 3;
 website = "www.ceshi.com";
 }
 */

@property (nonatomic, copy)NSString *head_pic;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *qr_code;
@property (nonatomic, copy)NSString *tel;
@property (nonatomic, copy)NSString *website;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *cardId;


+ (instancetype)cardModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
