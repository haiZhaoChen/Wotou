//
//  CHZTuiGuangViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/16.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZTuiGuangViewController.h"
#import "UIBarButtonItem+CHZ.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface CHZTuiGuangViewController ()<UIWebViewDelegate>
@property (nonatomic, copy)NSString *urlStr;
@property (weak, nonatomic) IBOutlet UIImageView *TGImgView;
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *upBtn;

@property (assign, nonatomic)BOOL isShow;

@end

@implementation CHZTuiGuangViewController

- (instancetype)initWithIMG:(NSString *)url{
    if (self = [super init]) {
        _urlStr = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 设置导航   */
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"rightShared" higlightedImage:@"rightShared_on" target:self action:@selector(sharedBtnClick)];
    // Do any additional setup after loading the view from its nib.
    [self.TGImgView sd_setImageWithURL:[NSURL URLWithString:_urlStr]];
    
    NSURL *url = [NSURL URLWithString:API_QRUSEINFO];
    
    _web.delegate = self;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    request.timeoutInterval = 10.0;
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

- (IBAction)getUseInfo:(UIButton *)sender {
    
    if (!_isShow) {
        //执行动画
        [UIView animateWithDuration:0.3 animations:^{
            
            _bgView.transform = CGAffineTransformMakeTranslation(0, -(kScreenWidth -40));
    
            [_upBtn setImage:[UIImage imageNamed:@"downdown"]];
        }];
    }else{
        //执行动画
        [UIView animateWithDuration:0.3 animations:^{
            
            _bgView.transform = CGAffineTransformIdentity;
            _TGImgView.transform = CGAffineTransformIdentity;
            [_upBtn setImage:[UIImage imageNamed:@"upup"]];
        }];
    }
    
    
    _isShow = !_isShow;
    
 
}


#pragma --mark 分享
- (void)sharedBtnClick{
    HZLog(@"转发");
    //1、创建分享参数
    NSArray* imageArray = @[_urlStr];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:nil
                                          title:@"关注我的窝头学堂"
                                           type:SSDKContentTypeImage];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
    
    
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
