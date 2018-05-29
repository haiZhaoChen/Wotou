//
//  CHZSettingGroup.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZSettingGroup : NSObject

@property (copy, nonatomic) NSString *header;
@property (copy, nonatomic) NSString *footer;
@property (strong, nonatomic) NSArray *items;

+ (instancetype)group;

@end
