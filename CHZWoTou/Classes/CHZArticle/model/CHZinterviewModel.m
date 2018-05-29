//
//  CHZinterviewModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZinterviewModel.h"

@implementation CHZinterviewModel

+ (instancetype)interviewWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        
        self.interviewId = [NSString stringWithFormat:@"%@",dict[@"id"]];;
        self.thumbnail = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"thumbnail"]];
        self.title = dict[@"title"];
        
    }
    
    return self;
}

@end
