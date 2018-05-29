//
//  CHZSettingItem.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^IWSettingItemOption)();

@interface CHZSettingItem : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *icon;
@property (weak, nonatomic)UIImage *imgIcon;
@property (copy, nonatomic) IWSettingItemOption option;
@property (copy, nonatomic) NSString *badgeValue;
@property (nonatomic,copy)NSString *flagUrl;
@property (nonatomic, assign)BOOL isRedPacket;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title imgIcon:(UIImage *)imgIcon;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)item;
@end
