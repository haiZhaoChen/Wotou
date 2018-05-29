//
//  CHZSettingViewController.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/16.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZSettingGroup;
@interface CHZSettingViewController : UITableViewController
@property (nonatomic, strong)NSMutableArray *groups;

- (CHZSettingGroup *)addGroup;
@end
