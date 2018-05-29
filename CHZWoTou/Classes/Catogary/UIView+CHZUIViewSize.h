//
//  UIView+CHZUIViewSize.h
//  CHZBaisi
//
//  Created by 陈海召 on 16/7/6.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CHZUIViewSize)

@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGSize size;


/**
 *  在分类中的property ,只会生成方法的声明，不会生成方法的实现
 */

@end
