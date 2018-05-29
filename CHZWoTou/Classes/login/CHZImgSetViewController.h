//
//  CHZImgSetViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnImgUrlBlock)(NSString *showText);


@interface CHZImgSetViewController : UIViewController

@property (nonatomic, assign)NSUInteger type;

@property (nonatomic, copy)ReturnImgUrlBlock returnImgUrlBlock;

- (void)returnIMGUrl:(ReturnImgUrlBlock)block;

@end
