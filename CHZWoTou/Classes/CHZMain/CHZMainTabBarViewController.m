//
//  CHZMainTabBarViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZMainTabBarViewController.h"
#import "CHZNavigationController.h"
#import "CHZBookViewController.h"
#import "CHZSharedMainViewController.h"
#import "CHZPersonalTableViewController.h"
#import "CHZBookVideoDetailViewController.h"

@interface CHZMainTabBarViewController ()

@end

@implementation CHZMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attr[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttr[NSForegroundColorAttributeName] = CHZBarButtonTitleColor;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    CHZNavigationController *nav1 = [[CHZNavigationController alloc] initWithRootViewController:[CHZSharedMainViewController new]];
    CHZNavigationController *nav2 = [[CHZNavigationController alloc] initWithRootViewController:[CHZBookViewController new]];
    CHZNavigationController *nav3 = [[CHZNavigationController alloc] initWithRootViewController:[CHZPersonalTableViewController new]];
    
    
    
    nav1.tabBarItem.title = @"分享";
    [nav1.tabBarItem setSelectedImage:[UIImage imageNamed:@"shared_click"]];
    nav1.tabBarItem.image = [UIImage imageNamed:@"shared"];
    
    nav2.tabBarItem.title = @"学堂";
    [nav2.tabBarItem setSelectedImage:[UIImage imageNamed:@"school_click"]];
    nav2.tabBarItem.image = [UIImage imageNamed:@"school"];

    nav3.tabBarItem.title = @"个人";
    [nav3.tabBarItem setSelectedImage:[UIImage imageNamed:@"personal_click"]];
    nav3.tabBarItem.image = [UIImage imageNamed:@"personal"];

    
    self.viewControllers = @[nav1, nav2, nav3];
    

    
    
}


//- (BOOL)shouldAutorotate
//{
//    UINavigationController *nav = self.viewControllers[1];
//    if ([nav.topViewController isKindOfClass:[CHZBookVideoDetailViewController class]]) {
//        return ![[[NSUserDefaults standardUserDefaults] objectForKey:@"ZXVideoPlayer_DidLockScreen"] boolValue];
//    }
//    
//    return NO;
//}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    UINavigationController *nav = self.viewControllers[1];
//    if ([nav.topViewController isKindOfClass:[CHZBookVideoDetailViewController class]]) {
//        return UIInterfaceOrientationMaskLandscapeRight;
//    }
//    
//    return UIInterfaceOrientationMaskPortrait;
//}


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
