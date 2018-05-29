//
//  CHZBookArticle.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/24.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZBookArticle : NSObject
/*
 {
 code = 202;
 data =     (
 {
 "add_time" = "<null>";
 auther = "<null>";
 comments = 0;
 description = "\U80dc\U591a\U8d1f\U5c11";
 id = 6;
 "read_counts" = 1;
 "share_counts" = 0;
 thumbnail = "<null>";
 title = "sdsa\U662f\U7684\U662f\U7684";
 },
 {
 "add_time" = 1484727491;
 auther = "";
 comments = 0;
 description = "\U4e09\U56db\U5341\U4e09\U56db\U5341\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240\U6240";
 id = 4;
 "read_counts" = 2;
 "share_counts" = 0;
 thumbnail = "20170118\\a219b9d2772caa7c0ecc59f9e3348581.png";
 title = "\U6d4b\U8bd5\U7528\U7684 \U7f8e\U6587\U4e00\U7bc7";
 },
 {
 "add_time" = 1481254277;
 auther = admin;
 comments = 0;
 description = "<p>\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790\U7f8e\U6587\U8d4f\U6790";
 id = 3;
 "read_counts" = 37;
 "share_counts" = 0;
 thumbnail = "20161209\\d76cee4596a2d276fd2883f1035b7e61.png";
 title = "\U589e\U52a0\U4e00\U7bc7\U7f8e\U6587\U6d4b\U8bd5\U4e0b";
 }
 );
 message = "\U6587\U7ae0\U5217\U8868";
 }
 */


@property (nonatomic, copy)NSString *auther;
@property (nonatomic, copy)NSString *bookArtDescription;
@property (nonatomic, copy)NSString *comments;
@property (nonatomic, copy)NSString *bookArtId;
@property (nonatomic, copy)NSString *read_counts;
@property (nonatomic, copy)NSString *share_counts;
@property (nonatomic, copy)NSString *thumbnail;
@property (nonatomic, copy)NSString *title;


+ (instancetype)articleDataWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
