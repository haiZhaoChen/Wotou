//
//  CHZPayViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZRegistModel;

@interface CHZPayViewController : UIViewController

+ (CHZPayViewController *)shareInstance;

@property (nonatomic,strong)CHZRegistModel *anyViewRegM;

/**
 *
 */
@property (nonatomic, assign) BOOL isLoginView;

- (instancetype)initWith:(CHZRegistModel *)regM;

@end
