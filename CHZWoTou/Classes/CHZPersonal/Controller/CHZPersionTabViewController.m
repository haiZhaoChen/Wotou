//
//  CHZPersionTabViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZPersionTabViewController.h"
#import "CHZSettingArrowItem.h"
#import "CHZSettingGroup.h"
#import "CHZMyAdvantageViewController.h"

@interface CHZPersionTabViewController ()

@end

@implementation CHZPersionTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CHZGlobalBg;
    self.navigationItem.title = @"微网设置";
    [self setupGroup0];
    [self setupGroup1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupGroup0{
    CHZSettingGroup *group = [self addGroup];
    

    CHZSettingArrowItem *item2 = [CHZSettingArrowItem itemWithIcon:@"" title:@"我的优势" imgIcon:nil destVcClass:[CHZMyAdvantageViewController class]];
    
    
    group.items = @[item2];
}

- (void)setupGroup1{
    
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
