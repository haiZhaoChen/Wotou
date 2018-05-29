//
//  CHZArticleData.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/22.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZArticleData.h"

@implementation CHZArticleData

/*
 @property (nonatomic, copy)NSString *add_time;
 @property (nonatomic, copy)NSString *articleDescription;
 @property (nonatomic, copy)NSString *read_counts;
 @property (nonatomic, copy)NSString *share_counts;
 @property (nonatomic, copy)NSString *title;
 */

+ (instancetype)articleDataWithDict:(NSDictionary *)dict{
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
        
        self.articleDescription = dict[@"description"];
        self.read_counts = [NSString stringWithFormat:@"%@",dict[@"read_counts"]];
        self.share_counts = [NSString stringWithFormat:@"%@",dict[@"share_counts"]];
        self.title = dict[@"title"];
        self.articleId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    }
    
    return self;
}

@end
