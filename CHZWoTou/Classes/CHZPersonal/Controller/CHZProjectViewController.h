//
//  CHZProjectViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZProjectModel;

typedef void (^ReturnUpdataBlock)(BOOL isNeedGet);

@interface CHZProjectViewController : UIViewController

@property (nonatomic, copy)NSString *navName;
@property (nonatomic, strong)CHZProjectModel *proModel;

@property (nonatomic, copy)ReturnUpdataBlock returnUpdataBlock;

- (void)returnText:(ReturnUpdataBlock)block;
@end
