//
//  CHZTuiGuangModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZTuiGuangModel : NSObject

/*
 code = 200;
 count = 3;
 data =     (
 {
 "add_time" = "2017\U5e7403\U670808\U65e5";
 message = "\U62dc\U62dc\U7528\U6237\U63a8\U5e7f\U6ce8\U518c";
 },
 {
 "add_time" = "2017\U5e7403\U670804\U65e5";
 message = "\U8def\U8def\U901a\U7528\U6237\U63a8\U5e7f\U6ce8\U518c";
 },
 {
 "add_time" = "2017\U5e7403\U670804\U65e5";
 message = "\U7b28\U86cb\U7528\U6237\U63a8\U5e7f\U6ce8\U518c";
 }
 );
 "last_month_count" = 0;
 message = "\U63a8\U5e7f\U8be6\U60c5";
 "month_count" = 3;

 */

@property (nonatomic, copy)NSString *count;
@property (nonatomic, copy)NSString *month_count;
@property (nonatomic, copy)NSString *last_month_count;
@property (nonatomic, copy)NSArray *infoArr;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
