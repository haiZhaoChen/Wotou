//
//  CHZUserVIPStateViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHZUserVIPStateViewController : UIViewController

+ (CHZUserVIPStateViewController *)shareInstance;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLB;

- (void)getUserRight;

@end
