//
//  CHZSettingLabelItem.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingLabelItem.h"

@implementation CHZSettingLabelItem

- (NSString *)text
{
    id value = [CHZUserDefaults objectForKey:self.key];
    if (value == nil) {
        return self.defaultText;
    } else {
        return value;
    }
}

- (void)setText:(NSString *)text
{
    [CHZUserDefaults setObject:text forKey:self.key];
    [CHZUserDefaults synchronize];
}
@end
