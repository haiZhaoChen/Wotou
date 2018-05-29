//
//  CHZGlobalInstance.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZGlobalInstance.h"

@implementation CHZGlobalInstance

+ (CHZGlobalInstance *)shareInstance{
    static CHZGlobalInstance* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

@end
