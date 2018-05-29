//
//  CHZTGInfoModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZTGInfoModel.h"

@implementation CHZTGInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.add_time = dict[@"add_time"];
        self.message = dict[@"message"];
    }
    return self;
}


@end
