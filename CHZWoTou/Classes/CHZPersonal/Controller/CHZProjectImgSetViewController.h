//
//  CHZProjectImgSetViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/8.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ReturnTextBlock)(NSString *showText);

@interface CHZProjectImgSetViewController : UIViewController

@property (nonatomic, assign)NSUInteger type;
@property (nonatomic, copy)NSString *imgNormal;

@property (nonatomic, copy)ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
