//
//  CHZBookText.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/14.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZBookText : NSObject
/*"add_time" = "2017-02-13 11:23:36";
 "book_name" = "\U5c0f\U77ee\U4eba";
 comments = 0;
 content = "/index.php/api/book/binfo.html?aid=6";
 id = 6;
 "read_counts" = 136;
 */

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *comments;
@property (nonatomic, copy)NSString *textId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *read_counts;


+ (instancetype)bookTextWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
