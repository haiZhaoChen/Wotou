//
//  CHZCommentModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/17.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZCommentModel : NSObject
/*
 "add_time" = "2017-02-15 17:27:55";
 content = "\U8c01\U7684\U597d\U5c11\U5987\U54c8";
 name = "\U6d4b\U8bd5\U7528\U62373";
 reply = "<null>";
 "reply_name" = "<null>";
 "reply_time" = "<null>";
 zan = 10;
 
 "add_time" = "02-17";
 cid = 19;
 content = "\U8bc4\U8bba\U4e00\U4e0b";
 "head_pic" = "/public/uploads/images/";
 "is_zan" = 0;
 name = "\U597d\U5427";
 reply = "<null>";
 "reply_name" = "<null>";
 "reply_time" = "<null>";
 zan = 0;
 */

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *reply;
@property (nonatomic, copy)NSString *reply_name;
@property (nonatomic, copy)NSString *reply_time;
@property (nonatomic, copy)NSString *zan;
@property (nonatomic, copy)NSString *cid;
@property (nonatomic, assign)BOOL is_zan;
@property (nonatomic, copy)NSString *head_pic;

+ (instancetype)commentModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
