//
//  CHZSettingViewController.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/16.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZSettingViewController.h"
#import "CHZSettingGroup.h"
#import "CHZSettingArrowItem.h"
#import "CHZSettingCheckGroup.h"
#import "CHZSettingCheckItem.h"
#import "CHZSettingCell.h"

const CGFloat CHZTableBorderW = 6;
const CGFloat CHZCellMargin = 6;


@implementation CHZSettingViewController
- (NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (CHZSettingGroup *)addGroup{
    CHZSettingGroup *group = [CHZSettingGroup group];
    [self.groups addObject:group];
    return group;
}

- (id)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.view.backgroundColor = CHZGlobalBg;
    self.tableView.sectionHeaderHeight = 0;//头部高度
    self.tableView.sectionFooterHeight = CHZCellMargin;//尾部高度
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, 0, 1);
    self.tableView.tableFooterView = footer;
    self.tableView.contentInset = UIEdgeInsetsMake(CHZCellMargin - 33, 0, 0, 0);
    

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CHZSettingGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHZSettingCell *cell = [CHZSettingCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    CHZSettingGroup *group = self.groups[indexPath.section];    
    cell.item = group.items[indexPath.row];
    
    return cell;
}

#pragma mark - 代理


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    CHZSettingGroup *group = self.groups[section];
    return group.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CHZSettingGroup *group = self.groups[section];
    return group.header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 1.取出模型
    CHZSettingGroup *group = self.groups[indexPath.section];
    CHZSettingItem *item = group.items[indexPath.row];
    
    // 2.操作
    if (item.option) {
        item.option();
    }
    
    // 3.跳转
    if ([item isKindOfClass:[CHZSettingArrowItem class]]) {
        CHZSettingArrowItem *arrowItem = (CHZSettingArrowItem *)item;
        if (arrowItem.destVcClass) {
            UIViewController *destVc = [[arrowItem.destVcClass alloc] init];
            destVc.title = arrowItem.title;
            
            if (arrowItem.readyForDestVc) { // 控制器的准备工作
                arrowItem.readyForDestVc(arrowItem, destVc);
            }
            
            [self.navigationController pushViewController:destVc animated:YES];
        }
    }
    
    // 4.check 打钩
    if ([item isKindOfClass:[CHZSettingCheckItem class]]) {
        CHZSettingCheckGroup *checkGroup = (CHZSettingCheckGroup *)group;
        checkGroup.checkedIndex = indexPath.row;
        
        // 刷新
        [tableView reloadData];
    }
    
}


@end
