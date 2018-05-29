//
//  CHZSettingValueItem.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingValueItem.h"

@implementation CHZSettingValueItem
- (NSString *)key{
    return _key ? _key :self.title;
}
@end
