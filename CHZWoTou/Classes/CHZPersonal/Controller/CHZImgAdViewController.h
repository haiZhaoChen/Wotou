//
//  CHZImgAdViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZADImgModel;
typedef void (^ReturnUpdataBlock)(BOOL isNeedGet);

@interface CHZImgAdViewController : UIViewController


@property (nonatomic, copy)NSString *navName;
@property (nonatomic, strong)CHZADImgModel *adModel;

@property (nonatomic, copy)ReturnUpdataBlock returnUpdataBlock;

- (void)returnText:(ReturnUpdataBlock)block;

@end
