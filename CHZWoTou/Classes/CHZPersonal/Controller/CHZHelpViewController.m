//
//  CHZHelpViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZHelpViewController.h"

@interface CHZHelpViewController ()<UIWebViewDelegate>

@end

@implementation CHZHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用帮助";
    self.view.backgroundColor = CHZGlobalBg;
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    web.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    NSURL *url = [NSURL URLWithString:API_HELP];
    
    web.delegate = self;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [web loadRequest: request];
    
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
