//
//  CHZSettingArrowItem.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingItem.h"
@class CHZSettingArrowItem;
typedef void (^CHZSettingArrowItemReadyForDestVc)(id item, id destVc);
@interface CHZSettingArrowItem : CHZSettingItem
@property (nonatomic, assign)Class destVcClass;
@property (nonatomic, copy)CHZSettingArrowItemReadyForDestVc readyForDestVc;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title imgIcon:(UIImage *)imgIcon destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

+ (instancetype)itemWithIconUrl:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
@end
