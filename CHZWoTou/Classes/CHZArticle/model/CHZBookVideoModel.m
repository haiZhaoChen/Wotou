//
//  CHZBookVideoModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/16.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookVideoModel.h"

@implementation CHZBookVideoModel


+ (instancetype)bookVideoWithDict:(NSDictionary *)dict{
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
        
        self.mp4 = [NSString stringWithFormat:@"%@",dict[@"mp4"]];
        self.comments = [NSString stringWithFormat:@"%@",dict[@"comments"]];
        self.musId = [NSString stringWithFormat:@"%@",dict[@"id"]];;
        self.mp4_content = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"mp4_content"]];
        self.read_counts = [NSString stringWithFormat:@"%@",dict[@"read_counts"]];
        self.book_name = dict[@"book_name"];
        
    }
    
    return self;
}

@end
