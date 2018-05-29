//
//  CHZLoginOutViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZLoginOutViewController.h"
#import "CHZLoginViewController.h"
#import "CHZPayViewController.h"
#import "CHZUserVIPStateViewController.h"
#import "CHZRegistModel.h"
#import "CHZUserInfoModel.h"
#import "CHZNavigationController.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@interface CHZLoginOutViewController ()

@end

@implementation CHZLoginOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)logout:(UIViewController *)VC{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"登录过期,请重新登陆"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [CHZUserDefaults setObject:nil forKey:@"token"];
        [CHZUserDefaults setObject:nil forKey:@"userId"];
        CHZLoginViewController *barVC = [[CHZLoginViewController alloc] init];
        [VC presentViewController:barVC animated:YES completion:^{
            
        }];
        
    });
}

+ (void)logoutNoMoney:(UIViewController *)VC{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"会员到期,请续费"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        CHZPayViewController *payVC = [CHZPayViewController shareInstance];
        CHZUserInfoModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:CHZAccountFile];
        /*
         self.name = dict[@"name"];
         self.payId = dict[@"id"];
         self.payMoney = dict[@"paymoney"];
         */
        CHZRegistModel *model = [[CHZRegistModel alloc] initWithDict:@{@"name":account.nickname,@"id":[CHZUserDefaults objectForKey:@"userId"],@"paymoney":account.paymoney}];
        payVC.anyViewRegM = model;
        CHZNavigationController *nav = [[CHZNavigationController alloc] initWithRootViewController:payVC];
        [VC presentViewController:nav animated:YES completion:^{
            
        }];
        
    });
}

+ (void)logoutBack:(UIViewController *)VC{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出当前账号" message:nil preferredStyle:0];
    
    UIAlertAction * logout = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CHZLoginViewController *barVC = [[CHZLoginViewController alloc] init];
        [VC presentViewController:barVC animated:YES completion:nil];
        //退出登陆，清空token
        
        [CHZUserDefaults setObject:nil forKey:@"token"];
        [CHZUserDefaults setObject:nil forKey:@"userId"];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:logout];
    [alert addAction:cancel];
    
    alert.popoverPresentationController.sourceView = VC.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    
    [VC presentViewController:alert animated:YES completion:^{
        
    }];
}

+ (void)logoutWithOtherLogin:(UIViewController *)VC{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
