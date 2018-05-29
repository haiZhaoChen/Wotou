//
//  CHZSetAccoutTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZSetAccoutTableViewController.h"
#import "CHZPwdEditViewController.h"
#import "CHZAboutWTViewController.h"
#import "CHZHelpViewController.h"

@interface CHZSetAccoutTableViewController ()
@property (nonatomic, strong)NSArray *namesArr;
@end

@implementation CHZSetAccoutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CHZGlobalBg;
    self.navigationItem.title = @"设置";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"personSetCell"];
    self.namesArr = @[@"使用帮助",@"修改密码",@"关于我们"];
    self.tableView.rowHeight = 44.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self setupFooter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.namesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personSetCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _namesArr[indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    if (indexPath.row == 0) {
        UILabel *label=[[UILabel alloc]init];
        label.text=@"使用说明";
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor grayColor];
        [label sizeToFit];
        label.frame=CGRectMake(kScreenWidth - label.frame.size.width-15, (44 - label.frame.size.height) *0.5, label.frame.size.width, label.frame.size.height);
        [cell.contentView addSubview:label];
    }else if (indexPath.row == 2){
        UILabel *label=[[UILabel alloc]init];
        label.text=@"窝头课堂";
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor grayColor];
        [label sizeToFit];
        label.frame=CGRectMake(kScreenWidth - label.frame.size.width-15, (44 - label.frame.size.height) *0.5, label.frame.size.width, label.frame.size.height);
        [cell.contentView addSubview:label];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        CHZPwdEditViewController *pwdEditVC = [[CHZPwdEditViewController alloc] init];
        [self.navigationController pushViewController:pwdEditVC animated:YES];
    }else if(indexPath.row == 2){
        CHZAboutWTViewController *aboutWTVC = [[CHZAboutWTViewController alloc] init];
        [self.navigationController pushViewController:aboutWTVC animated:YES];

    }else if (indexPath.row == 0){
     
        CHZHelpViewController *helpVC = [[CHZHelpViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
}

- (void)setupFooter
{
    // 按钮
    UIButton *logoutButton = [[UIButton alloc] init];
    CGFloat logoutX = 8;
    CGFloat logoutY = 8;
    CGFloat logoutW = self.tableView.frame.size.width - 2 * logoutX;
    CGFloat logoutH = 44;
    logoutButton.frame = CGRectMake(logoutX, logoutY, logoutW, logoutH);
    

    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.cornerRadius = 5.f;
    [logoutButton setBackgroundColor:CHZRGBColor(142, 66, 25)];
    [logoutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = 35 + 6;
    footer.frame = CGRectMake(0, 8, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:logoutButton];
}

- (void)logoutBtnClick{
    [CHZLoginOutViewController logoutBack:self];
    
}


@end
