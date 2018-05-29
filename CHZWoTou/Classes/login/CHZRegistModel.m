//
//  CHZRegistModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/16.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZRegistModel.h"

@implementation CHZRegistModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.payId = dict[@"id"];
        self.payMoney = dict[@"paymoney"];
    }
    
    return self;
}

@end
