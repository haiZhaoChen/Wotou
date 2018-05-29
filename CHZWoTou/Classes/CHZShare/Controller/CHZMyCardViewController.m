//
//  CHZMyCardViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/20.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZMyCardViewController.h"

@interface CHZMyCardViewController ()<UIWebViewDelegate>
@property (nonatomic, copy)NSString *website;
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation CHZMyCardViewController

- (instancetype)initWithWebsite:(NSString *)website{
    if (self = [super init]) {
        _website = website;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的官网";
    self.view.backgroundColor = CHZGlobalBg;
    // Do any additional setup after loading the view from its nib.
    
    
    NSURL *url = [NSURL URLWithString:_website];
    
    _web.delegate = self;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_web loadRequest: request];
    
    
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
