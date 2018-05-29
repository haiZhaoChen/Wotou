//
//  CHZSettingItem.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingItem.h"

@implementation CHZSettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title imgIcon:(UIImage *)imgIcon
{
    CHZSettingItem *item = [self item];
    item.icon = icon;
    item.title = title;
    item.imgIcon = imgIcon;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title imgIcon:nil];
}

+ (instancetype)item
{
    return [[self alloc] init];
}
@end
