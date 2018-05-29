//
//  CHZBookMusModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/13.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "add_time" = "2017-02-13 11:23:36";
 "book_name" = "\U5c0f\U77ee\U4eba";
 comments = 0;
 id = 6;
 mp3 = "/public/uploads/mp4/20161208/14811876067d184d465768fe93.mp3";
 "mp3_content" = "/index.php/api/book/mp3info.html?aid=6";
 "read_counts" = 45;
 */


@interface CHZBookMusModel : NSObject

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *mp3;
@property (nonatomic, copy)NSString *comments;
@property (nonatomic, copy)NSString *musId;
@property (nonatomic, copy)NSString *mp3_content;
@property (nonatomic, copy)NSString *read_counts;


+ (instancetype)bookMusWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
