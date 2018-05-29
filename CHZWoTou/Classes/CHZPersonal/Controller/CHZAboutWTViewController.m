//
//  CHZAboutWTViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/16.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZAboutWTViewController.h"

@interface CHZAboutWTViewController ()<UIWebViewDelegate>

@end

@implementation CHZAboutWTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = CHZGlobalBg;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*0.5 - 30, 10, 60, 60)];
    imgView.image = [UIImage imageNamed:@"iconImg"];
    imgView.layer.masksToBounds = YES;
    imgView.layer.cornerRadius = 5;
    [bgView addSubview:imgView];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(bgView.frame))];
    
    web.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    NSURL *url = [NSURL URLWithString:API_ABOUTWOTOU];
    
    web.delegate = self;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [web loadRequest: request];
    web.scrollView.bounces = NO;
    [self.view addSubview:bgView];
    [self.view addSubview:web];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"页面加载失败"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
