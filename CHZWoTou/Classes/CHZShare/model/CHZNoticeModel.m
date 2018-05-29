//
//  CHZNoticeModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZNoticeModel.h"

@implementation CHZNoticeModel

+ (instancetype)noticeWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        if (dict[@"thumbnail"] != [NSNull null]) {
            self.thumbnail = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"thumbnail"]];
        }else{
            self.thumbnail = @"";
        }
        if (dict[@"title"] != [NSNull null]) {
            self.title = dict[@"title"];
        }else{
            self.title = @"";
        }
        if (dict[@"id"] != [NSNull null]) {
            self.nId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        }else{
            self.nId = @"";
        }
        
        
        
        
    }
    return self;
}

@end
