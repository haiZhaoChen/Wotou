//
//  CHZMapModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZMapModel.h"

@implementation CHZMapModel

+ (instancetype)mapModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.mapId  = [NSString stringWithFormat:@"%@",dict[@"id"]];
        self.name = dict[@"name"];
        self.s_name = dict[@"s_name"];
    }
    
    return self;
}


@end
