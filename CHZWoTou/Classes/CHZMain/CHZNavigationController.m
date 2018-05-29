//
//  CHZNavigationController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZNavigationController.h"

@interface CHZNavigationController ()

@end

@implementation CHZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CHZGlobalBg;
    
}

/**
 *  写在这个方法里拦截push后的控制器
 */

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0 ) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"return_whight"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"return_gray"] forState:UIControlStateHighlighted];
        backBtn.size = CGSizeMake(70, 30);
        
        //设置靠左
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        //设置文字颜色
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        //添加事件
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        //push控制器后把下面的tabBar消失掉
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    
    [super pushViewController:viewController animated:animated];
    
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

/**
 *  当第一次使用这个类的时候才会调用一次。。
 */
+ (void)initialize{
    HZLogFunc;
    UINavigationBar *NB = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
//    NB.backgroundColor = [UIColor orangeColor];
    [NB setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    
    // 1.设置导航栏主题
    [self setupNavBarTheme];
    
    // 2.设置导航栏按钮的主题
    [self setupBarButtonTheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  设置导航栏按钮的主题
 */
+ (void)setupBarButtonTheme
{
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    // 2.设置按钮的文字样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = CHZBarButtonTitleColor;
    //    attrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    attrs[NSFontAttributeName] = CHZBarButtonTitleFont;
    [barItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:attrs forState:UIControlStateHighlighted];
    
    NSMutableDictionary *disableAttrs = [NSMutableDictionary dictionary];
    disableAttrs[NSForegroundColorAttributeName] = CHZBarButtonTitleDisabledColor;
    
    //    disableAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    [barItem setTitleTextAttributes:disableAttrs forState:UIControlStateDisabled];
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    // 1.获得bar对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    
    // 3.设置文字样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = CHZNavigationBarTitleColor;
    attrs[NSFontAttributeName] = CHZNavigationBarTitleFont;
    //    attrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    [navBar setTitleTextAttributes:attrs];
    
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (self.viewControllers.count) {
//        viewController.hidesBottomBarWhenPushed = YES;
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_back" higlightedImage:@"navigationbar_back_highlighted" target:self action:@selector(back)];
//        //        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_more" higlightedImage:@"navigationbar_more_highlighted" target:self action:@selector(more)];
//    }
//    [super pushViewController:viewController animated:animated];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
