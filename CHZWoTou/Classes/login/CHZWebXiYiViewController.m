//
//  CHZWebXiYiViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/15.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZWebXiYiViewController.h"

@interface CHZWebXiYiViewController ()<UIWebViewDelegate>

@end

@implementation CHZWebXiYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置背景色
    self.navigationItem.title = @"用户协议";
    self.view.backgroundColor = CHZGlobalBg;
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    web.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    NSURL *url = [NSURL URLWithString:API_XIYI];
    
    web.delegate = self;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [web loadRequest: [NSURLRequest requestWithURL:url]];
    
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
