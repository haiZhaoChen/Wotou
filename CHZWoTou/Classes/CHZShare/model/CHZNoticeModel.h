//
//  CHZNoticeModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "add_time" = 1486711153;
 author = admin;
 content = "<p>\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7\U6dfb\U52a0\U4e00\U7bc7</p>";
 id = 3;
 thumbnail = "/public/uploads/images/20170210/42021abeda9ab78ff356efec94bc58af.jpg";
 title = "\U6dfb\U52a0\U4e00\U7bc7";
 }
 */

@interface CHZNoticeModel : NSObject
@property (nonatomic, copy)NSString *thumbnail;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *nId;

+ (instancetype)noticeWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
