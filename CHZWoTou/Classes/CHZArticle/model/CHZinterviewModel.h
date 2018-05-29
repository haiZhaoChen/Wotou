//
//  CHZinterviewModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZinterviewModel : NSObject

/*
 
 code = 202;
 data =     (
 {
 id = 6;
 thumbnail = "/public/uploads/images/20170207/thumb_ac36340992940e046ae085f4d6a8b4c2.jpg";
 title = "\U6dfb\U52a0\U4e00\U7bc7\U4eba\U7269\U4e13\U8bbf";
 },
 {
 id = 5;
 thumbnail = "/public/uploads/images/20170207/thumb_3235e0fd89f3c514c509ce45556a33f4.png";
 title = "\U6dfb\U52a0\U4e00\U7bc7\U4eba\U7269\U4e13\U8bbf";
 },
 {
 id = 3;
 thumbnail = "/public/uploads/images/20170106\\138d107761b91866e86600a5c92f41fc.jpg";
 title = "\U671d\U82b1\U5915\U62fe";
 },
 {
 id = 2;
 thumbnail = "/public/uploads/images/20161209\\a4a5dade97d2c8d811302e3b7ef0e953.jpg";
 title = "\U5c0f\U8bf4\U7cbe\U9009";
 }
 );
 message = "\U6587\U7ae0\U5217\U8868";
 */

@property (nonatomic, copy)NSString *interviewId;
@property (nonatomic, copy)NSString *thumbnail;
@property (nonatomic, copy)NSString *title;


+ (instancetype)interviewWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
