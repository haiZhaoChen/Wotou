//
//  CHZTitleName.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/22.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZTitleName.h"

@implementation CHZTitleName

+ (instancetype)titleNameWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.nameId = dict[@"id"];
        self.name = dict[@"name"];
        self.pid = dict[@"pid"];
    }
    
    return self;
}

@end
