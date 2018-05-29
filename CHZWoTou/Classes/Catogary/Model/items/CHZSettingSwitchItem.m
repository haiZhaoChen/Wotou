//
//  CHZSettingSwitchItem.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/16.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingSwitchItem.h"

@implementation CHZSettingSwitchItem

- (id)init
{
    if (self = [super init]) {
        self.defaultOn = YES;
    }
    return self;
}

- (BOOL)isOn
{
    id value = [CHZUserDefaults objectForKey:self.key];
    if (value == nil) {
        return self.isDefaultOn;
    } else {
        return [value boolValue];
    }
}

- (void)setOn:(BOOL)on
{
    [CHZUserDefaults setBool:on forKey:self.key];
    [CHZUserDefaults synchronize];
}
@end
