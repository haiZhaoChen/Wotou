//
//  CHZSettingCell.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/16.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHZBgCell.h"
@class CHZSettingItem;

@interface CHZSettingCell : CHZBgCell

@property(nonatomic,strong)CHZSettingItem *item;
@property(nonatomic,strong)NSIndexPath *indexPath;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
