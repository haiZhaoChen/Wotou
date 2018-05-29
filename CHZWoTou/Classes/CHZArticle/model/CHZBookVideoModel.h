//
//  CHZBookVideoModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/16.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZBookVideoModel : NSObject

/*"add_time" = "2017-02-16 10:31:11";
 "book_name" = "\U5c0f\U77ee\U4eba";
 comments = 0;
 id = 6;
 mp4 = "/public/uploads/mp4/20170125/14853222517f9c970486e8452b.mp4";
 "mp4_content" = "/index.php/api/book/mp4info.html?aid=6";
 "read_counts" = 352;
 */

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *mp4;
@property (nonatomic, copy)NSString *comments;
@property (nonatomic, copy)NSString *musId;
@property (nonatomic, copy)NSString *mp4_content;
@property (nonatomic, copy)NSString *read_counts;
@property (nonatomic, copy)NSString *book_name;


+ (instancetype)bookVideoWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
