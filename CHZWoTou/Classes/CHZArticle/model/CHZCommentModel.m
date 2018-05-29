//
//  CHZCommentModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/17.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZCommentModel.h"

@implementation CHZCommentModel
/*
 @property (nonatomic, copy)NSString *add_time;
 @property (nonatomic, copy)NSString *content;
 @property (nonatomic, copy)NSString *name;
 @property (nonatomic, copy)NSString *reply;
 @property (nonatomic, copy)NSString *reply_name;
 @property (nonatomic, copy)NSString *reply_time;
 @property (nonatomic, copy)NSString *zan;
 
 @property (nonatomic, copy)NSString *cid;
 @property (nonatomic, assign)BOOL *is_zan;
 @property (nonatomic, copy)NSString *head_pic;
 */

+ (instancetype)commentModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.add_time = dict[@"add_time"];
        self.content = dict[@"content"];
        self.name = dict[@"name"];
        if (dict[@"reply"] != [NSNull null]) {
            self.reply = dict[@"reply"];
        }else{
            self.reply = @"";
        }
        if (dict[@"reply_name"] != [NSNull null]) {
            self.reply_name = dict[@"reply_name"];
        }else{
            self.reply_name = @"管理员";
        }
        
        self.zan = [NSString stringWithFormat:@"%@",dict[@"zan"]];
        
        self.cid = [NSString stringWithFormat:@"%@",dict[@"cid"]];
        if (dict[@"head_pic"] != [NSNull null]) {
            self.head_pic = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"head_pic"]];
        }else{
            self.head_pic = @"";
        }
        
        self.is_zan = [dict[@"is_zan"] boolValue];
        
        
    }
    return self;
}

@end
