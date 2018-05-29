//
//  CHZBookText.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/14.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookText.h"

@implementation CHZBookText
/*
 @property (nonatomic, copy)NSString *add_time;
 @property (nonatomic, copy)NSString *comments;
 @property (nonatomic, copy)NSString *textId;
 @property (nonatomic, copy)NSString *content;
 @property (nonatomic, copy)NSString *read_counts;
 */

+ (instancetype)bookTextWithDict:(NSDictionary *)dict{
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
        self.comments = [NSString stringWithFormat:@"%@",dict[@"comments"]];
        self.textId = [NSString stringWithFormat:@"%@",dict[@"id"]];;
        self.content = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"content"]];
        self.read_counts = [NSString stringWithFormat:@"%@",dict[@"read_counts"]];
        
        
    }
    
    return self;
}


@end
