//
//  CHZSettingCheckGroup.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/15.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingGroup.h"



@class CHZSettingCheckItem, CHZSettingLabelItem;

@interface CHZSettingCheckGroup : CHZSettingGroup
/**
 *  选中的索引
 */
@property (assign, nonatomic) NSInteger checkedIndex;

/**
 *  选中的item
 */
@property (strong, nonatomic) CHZSettingCheckItem *checkedItem;

/**
 *  来源于哪个item
 */
@property (strong, nonatomic) CHZSettingLabelItem *sourceItem;
@end
