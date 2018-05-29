//
//  CHZBookArticleModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/15.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookArticleModel.h"

@implementation CHZBookArticleModel

+ (instancetype)bookArticleModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
    
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        if (dict[@"add_time"] != [NSNull null]) {
            NSString *timeStr = dict[@"add_time"];
            if (timeStr.length >10) {
                self.add_time = [dict[@"add_time"] substringToIndex:10];
            }else{
                self.add_time = timeStr;
            }
            
        }
        self.auther = dict[@"auther"];
        self.comments = [NSString stringWithFormat:@"%@",dict[@"comments"]];
        self.aId = [NSString stringWithFormat:@"%@",dict[@"id"]];;
        self.content = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"content"]];
        self.read_counts = [NSString stringWithFormat:@"%@",dict[@"read_counts"]];
        self.share_counts = [NSString stringWithFormat:@"%@",dict[@"share_counts"]];
        self.title = dict[@"title"];
        
        
        
    }
    
    return self;
}

@end
