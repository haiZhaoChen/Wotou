//
//  CHZSettingSwitchItem.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/16.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingValueItem.h"

@interface CHZSettingSwitchItem : CHZSettingValueItem
@property (assign, nonatomic, getter = isOn) BOOL on;
@property (assign, nonatomic, getter = isDefaultOn) BOOL defaultOn;
@end
