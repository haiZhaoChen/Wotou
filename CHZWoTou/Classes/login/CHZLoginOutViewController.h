//
//  CHZLoginOutViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHZLoginOutViewController : UIViewController

+ (void)logout:(UIViewController *)VC;
+ (void)logoutBack:(UIViewController *)VC;

+ (void)logoutWithOtherLogin:(UIViewController *)VC;

+ (void)logoutNoMoney:(UIViewController *)VC;

@end
