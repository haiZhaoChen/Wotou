//
//  CHZBookArticleModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/15.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZBookArticleModel : NSObject
/*
 {
 card =     {
 "head_pic" = "20170214/85d971c50140807d777bc94ba5303734.jpg";
 id = 3;
 nickname = Chene;
 "qr_code" = "20170212/4f0779fb5051c2ec661c891d494e3d57.jpg";
 tel = 546565668;
 uid = 3;
 website = "http://www.ceshi.com";
 };
 code = 200;
 data =     {
 "add_time" = "2017-02-13 11:25:08";
 auther = "\U54c8\U54c8";
 comments = 0;
 content = "/index.php/api/book/ainfo.html?aid=7";
 id = 7;
 "read_counts" = 25;
 "share_counts" = 0;
 title = "\U65b0\U589e\U4e00\U7bc7\U7f8e\U6587\U6587\U7ae0";
 };
 message = "\U6587\U7ae0\U8be6\U60c5";
 }
 */

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *auther;
@property (nonatomic, copy)NSString *comments;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *read_counts;
@property (nonatomic, copy)NSString *share_counts;
@property (nonatomic, copy)NSString *aId;


+ (instancetype)bookArticleModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;



@end
