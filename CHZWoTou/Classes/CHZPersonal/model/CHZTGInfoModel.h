//
//  CHZTGInfoModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZTGInfoModel : NSObject
/*
 "add_time" = "2017\U5e7403\U670804\U65e5";
 message = "\U8def\U8def\U901a\U7528\U6237\U63a8\U5e7f\U6ce8\U518c";
 */

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *message;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
