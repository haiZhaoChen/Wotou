//
//  UIBarButtonItem+CHZ.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/14.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "UIBarButtonItem+CHZ.h"

@implementation UIBarButtonItem (CHZ)
+ (UIBarButtonItem *)itemWithImage:(NSString *)image higlightedImage:(NSString *)higlightedImage target:(id)target action:(SEL)action
{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 2.设置按钮背景图片
    UIImage *normal = [UIImage imageWithName:image];
    [btn setBackgroundImage:normal forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithName:higlightedImage] forState:UIControlStateHighlighted];
    
    // 3.设置按钮的尺寸
    btn.bounds = CGRectMake(0, 0, normal.size.width*0.8, normal.size.height*0.8);
    
    // 4.监听按钮点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 5.返回创建好的item
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end

