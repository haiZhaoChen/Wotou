//
//  CHZPersonalMainTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZPersonalMainTableViewController.h"
#import "CHZPortraitTableViewCell.h"
#import "CHZQRCodeTableViewCell.h"
#import "CHZChangeInfoViewController.h"
#import "CHZUserInfoModel.h"
#import "CHZIconImgSetViewController.h"
#import "CHZQRCodeChangeViewController.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#define LASTONE 9

@interface CHZPersonalMainTableViewController ()
@property (nonatomic, strong)NSArray *namesArr;
@property (nonatomic, strong)NSArray *valuesArr;
@property (nonatomic, strong)NSArray *warningNameArr;

//userInfo
@property (nonatomic, strong)CHZUserInfoModel *userInfo;
@end

@implementation CHZPersonalMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navName;
    
    
    
    self.namesArr = @[@"",@"昵  称",@"电子邮箱",@"公司地址",@"业务电话",@"公司简介",@"官网地址",@"微  信",@"Q  Q",@""];
    self.warningNameArr = @[@"",@"昵称设置两个字符到六个字符之间",@"例如:***@163.com",@"",@"",@"",@"例如:www.wt668.com",@"",@"",@""];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZPortraitTableViewCell class]) bundle:nil] forCellReuseIdentifier:CHZPersonalDT];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZQRCodeTableViewCell class]) bundle:nil] forCellReuseIdentifier:CHZQRCode];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"personalDT"];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:CHZAccountFile];
    self.valuesArr = @[@"",self.userInfo.nickname,self.userInfo.email,self.userInfo.address,self.userInfo.tel,self.userInfo.detail,self.userInfo.website,self.userInfo.wechat,self.userInfo.qq,self.userInfo.qr_code];
    if (self.userInfo.head_pic.length) {
        CHZPortraitTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:self.userInfo.head_pic] placeholderImage:[UIImage imageNamed:@"perImg"]];
    }
    
    if (self.userInfo.qr_code.length) {
        CHZQRCodeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:LASTONE inSection:0]];
        cell.qr_code = self.valuesArr[LASTONE];
    }
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
    
    if (0 == indexPath.row) {
        CHZPortraitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHZPersonalDT forIndexPath:indexPath];
        cell.backgroundColor = CHZRGBColor(220, 220, 220);
        if (self.userInfo.head_pic) {
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:self.userInfo.head_pic] placeholderImage:[UIImage imageNamed:@"perImg"]];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
        return cell;
    }
    if (LASTONE == indexPath.row) {
        CHZQRCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHZQRCode forIndexPath:indexPath];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
        cell.qr_code = self.valuesArr[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalDT" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"personalDT"];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
    
    NSString *str = self.namesArr[indexPath.row];
    
    cell.textLabel.text = str;
    
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 ==  indexPath.row) {
        return 90.0f;
    }
    if (LASTONE == indexPath.row) {
        return 70.0f;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
//        [self EditAlertShow];
        
        CHZIconImgSetViewController *imgVC = [[CHZIconImgSetViewController alloc] init];
        if (self.userInfo.head_pic) {
            imgVC.imgNormal = self.userInfo.head_pic;
        }
        [self.navigationController pushViewController:imgVC animated:YES];
    }else if (LASTONE == indexPath.row){
        CHZQRCodeChangeViewController *qrCodeVC = [[CHZQRCodeChangeViewController alloc] init];
        qrCodeVC.imgNormal = self.userInfo.qr_code;
        [self.navigationController pushViewController:qrCodeVC animated:YES];
        
    }else{
        NSString *str = self.namesArr[indexPath.row];
        NSString *valueStr = self.valuesArr[indexPath.row];
        CHZChangeInfoViewController * changeInfoVC = [[CHZChangeInfoViewController alloc] init];
        changeInfoVC.theName = str;
        changeInfoVC.theWarning = self.warningNameArr[indexPath.row];
        changeInfoVC.type = indexPath.row;
        if (valueStr) {
            changeInfoVC.theText = valueStr;
        }
        
        [self.navigationController pushViewController:changeInfoVC animated:YES];
    }
    
}













/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
