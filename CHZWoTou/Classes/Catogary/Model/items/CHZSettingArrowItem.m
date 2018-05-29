//
//  CHZSettingArrowItem.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingArrowItem.h"

@implementation CHZSettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title imgIcon:(UIImage *)imgIcon destVcClass:(Class)destVcClass{
    CHZSettingArrowItem *item = [self itemWithIcon:icon title:title imgIcon:imgIcon];
    item.destVcClass = destVcClass;
    return item;
    
    
}
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass{
    return [self itemWithIcon:nil title:title imgIcon:nil destVcClass:destVcClass];
}

+ (instancetype)itemWithIconUrl:(NSString *)icon title:(NSString *)title  destVcClass:(Class)destVcClass{
    CHZSettingArrowItem *item = [self itemWithIcon:icon title:title imgIcon:nil];
    item.destVcClass = destVcClass;
    return item;
    
    
}

@end
