//
//  CHZPickView.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/13.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

typedef void(^btnActionBlock)(NSInteger xianId, NSString *xianName);

@interface CHZPickView : UIView

@property (copy, nonatomic) btnActionBlock btnActionBlock;

- (void)show;

- (void)dismiss;

- (instancetype)initWithAgentArr:(NSArray *)agentArr;

@end
