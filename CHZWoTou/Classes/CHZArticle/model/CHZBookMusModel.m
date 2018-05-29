//
//  CHZBookMusModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/13.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookMusModel.h"

@implementation CHZBookMusModel
/*@property (nonatomic, copy)NSString *add_time;
 @property (nonatomic, copy)NSString *mp3;
 @property (nonatomic, copy)NSString *comments;
 @property (nonatomic, copy)NSString *musId;
 @property (nonatomic, copy)NSString *mp3_content;
 @property (nonatomic, copy)NSString *read_counts;*/

+ (instancetype)bookMusWithDict:(NSDictionary *)dict{
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
        
        self.mp3 = [NSString stringWithFormat:@"%@",dict[@"mp3"]];
        self.comments = [NSString stringWithFormat:@"%@",dict[@"comments"]];
        self.musId = [NSString stringWithFormat:@"%@",dict[@"id"]];;
        self.mp3_content = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"mp3_content"]];
        self.read_counts = [NSString stringWithFormat:@"%@",dict[@"read_counts"]];
        
        
    }
    
    return self;
}

@end
