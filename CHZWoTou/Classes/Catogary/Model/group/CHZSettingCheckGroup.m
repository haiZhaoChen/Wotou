//
//  CHZSettingCheckGroup.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingCheckGroup.h"
#import "CHZSettingCheckItem.h"
#import "CHZSettingLabelItem.h"

@implementation CHZSettingCheckGroup

- (CHZSettingCheckItem *)checkedItem
{
    for (CHZSettingCheckItem *item in self.items) {
        if (item.isChecked) return item;
    }
    return nil;
}

- (void)setCheckedItem:(CHZSettingCheckItem *)checkedItem
{
    for (CHZSettingCheckItem *item in self.items) {
        item.checked = (item == checkedItem);
    }
    self.sourceItem.text = checkedItem.title;
}

- (NSInteger)checkedIndex
{
    for (int i = 0; i<self.items.count; i++) {
        CHZSettingCheckItem *item = self.items[i];
        if (item.isChecked) return i;
    }
    return -1;
}

- (void)setCheckedIndex:(NSInteger)checkedIndex
{
    if (checkedIndex <0 || checkedIndex >= self.items.count) return;
    
    self.checkedItem = self.items[checkedIndex];
}

- (void)setItems:(NSArray *)items
{
    [super setItems:items];
    
    self.sourceItem = self.sourceItem;
}

- (void)setSourceItem:(CHZSettingLabelItem *)sourceItem
{
    _sourceItem = sourceItem;
    
    for (CHZSettingCheckItem *item in self.items) {
        item.checked = [item.title isEqualToString:self.sourceItem.text];
    }
}
@end
