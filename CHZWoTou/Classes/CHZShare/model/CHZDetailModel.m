
//
//  CHZDetailModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZDetailModel.h"

@implementation CHZDetailModel
/*
@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *agent;//代理人
@property (nonatomic, copy)NSString *auther;
@property (nonatomic, copy)NSString *column;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *kDescription;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *read_counts;
@property (nonatomic, copy)NSString *share_counts;
@property (nonatomic, copy)NSString *aId;
@property (nonatomic, copy)NSString *type;

*/

+ (instancetype)detailModelWithDict:(NSDictionary *)dict{
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
        self.agent = dict[@"agent"];
        self.auther = dict[@"auther"];
        self.column = [NSString stringWithFormat:@"%@",dict[@"column"]];
        self.content = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"content"]];
        self.kDescription = dict[@"kDescription"];
        self.title = dict[@"title"];
        self.read_counts = [NSString stringWithFormat:@"%@",dict[@"read_counts"]];
        self.share_counts = [NSString stringWithFormat:@"%@",dict[@"share_counts"]];
        self.aId = [NSString stringWithFormat:@"%@",dict[@"aId"]];
        self.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
        
    }
    
    return self;
}

@end
