//
//  CHZMapModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 id = 34;
 name = "\U6fb3\U95e8";
 "s_name" = "\U6fb3";
 */

@interface CHZMapModel : NSObject

@property (nonatomic, copy)NSString *mapId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *s_name;


+ (instancetype)mapModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
