//
//  CHZArticleData.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/22.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZArticleData : NSObject
/*
 "add_time" = "2016-12-14 15:48:37";
 description = "";
 id = 5315;
 "read_counts" = 1795;
 "share_counts" = 0;
 title = "13\U53e5\U8425\U9500\U8bdd\U672f\U7ecf\Uff0c\U8ba9\U987e\U5ba2\U6ca1\U7406\U7531\U62d2\U7edd\U4f60\Uff01";
 */

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *articleDescription;
@property (nonatomic, copy)NSString *read_counts;
@property (nonatomic, copy)NSString *share_counts;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *articleId;

+ (instancetype)articleDataWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
