//
//  CHZUserVIPStateViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZUserVIPStateViewController.h"
#import "CHZUserInfoModel.h"
#import "WXApi.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "CHZGlobalInstance.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@interface CHZUserVIPStateViewController ()<UIWebViewDelegate>


@property (nonatomic,strong)CHZUserInfoModel *userModel;
@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UIWebView *VIPRightView;

@end

@implementation CHZUserVIPStateViewController


+ (CHZUserVIPStateViewController *)shareInstance{
    static CHZUserVIPStateViewController* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}


- (IBAction)gotoPayMoney:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"body"] = [NSString stringWithFormat:@"%@\n窝头学堂会员续费",self.userModel.nickname];
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"total_fee"] = self.userModel.paymoney;
    params[@"ip"] = [self getIpAddresses];
    
    [self.mgr POST:API_PAYFORWECHAT parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"调起支付成功");
        /*
         appid = wxdd059f98e09921e2;
         "mch_id" = 1432590602;
         "nonce_str" = D0LBPUEZMYk1mAn3;
         "prepay_id" = wx2017031615434361a0e963e20290570190;
         "result_code" = SUCCESS;
         "return_code" = SUCCESS;
         "return_msg" = OK;
         sign = 40FE93D5AB57439BFFC6CD55D7C34C45;
         timestamp = 1489650224;
         "trade_type" = APP;
         */
        if ([responseObject[@"result_code"] isEqualToString:@"SUCCESS"]) {
            
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = responseObject[@"mch_id"];
            request.prepayId= responseObject[@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr= responseObject[@"nonce_str"];
            request.timeStamp= [responseObject[@"timestamp"] unsignedIntValue];
            request.sign= responseObject[@"sign"];
            
            [WXApi sendReq:request];
            [CHZGlobalInstance shareInstance].gotoWitchView = 222;
        }else{
            [SVProgressHUD showErrorWithStatus:@"请稍后再试"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error);
    }];
    
}

- (NSString *)getIpAddresses{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:CHZAccountFile];
    if (self.userModel) {
        _nameLB.text = self.userModel.nickname;
        _endTimeLB.text = self.userModel.end_time;
        _moneyLB.text = [NSString stringWithFormat:@"1年(%@元)",self.userModel.paymoney];
    }
    [self getUserRight];
}

- (void)getUserRight{
    
    NSURL *url = [NSURL URLWithString:API_VIPRIGHT];
    
    self.VIPRightView.delegate = self;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [self.VIPRightView loadRequest: request];
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

+ (void)getMoreUserInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 说明服务器返回的JSON数据
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr POST:API_USERINFO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"调用个人信息接口成功");
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != nil && responseObject[@"data"] !=[NSNull null]) {
                CHZUserInfoModel *userInfo = [[CHZUserInfoModel alloc] initWithDict:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });
                [NSKeyedArchiver archiveRootObject:userInfo toFile:CHZAccountFile];
                
            }
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error);
    }];

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
