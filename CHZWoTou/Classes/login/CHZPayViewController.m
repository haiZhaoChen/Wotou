//
//  CHZPayViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZPayViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "WXApi.h"
#import "CHZRegistModel.h"
#import "CHZLoginViewController.h"
#import "CHZGlobalInstance.h"

@interface CHZPayViewController ()<WXApiDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (nonatomic,strong)CHZRegistModel *regM;

@property (nonatomic, assign)BOOL isWitchView;

@end

@implementation CHZPayViewController

+ (CHZPayViewController *)shareInstance{
    static CHZPayViewController* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

- (void)setAnyViewRegM:(CHZRegistModel *)anyViewRegM{
    _anyViewRegM = anyViewRegM;
    _regM = anyViewRegM;
    self.isWitchView = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isWitchView = NO;
}

- (instancetype)initWith:(CHZRegistModel *)regM{
    if (self = [super init]) {
        _regM = regM;
    }
    return self;
}

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        //        [AFHTTPResponseSerializer serializer];
        //
    }
    
    return _mgr;
}

- (IBAction)commitPay:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"body"] = [NSString stringWithFormat:@"%@-注册窝头学堂",_regM.name];
    params[@"uid"] = _regM.payId;
    params[@"total_fee"] = _regM.payMoney;
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
            if (self.isWitchView) {
                [CHZGlobalInstance shareInstance].gotoWitchView = 666;
            }else{
                if (self.isWitchView) {
                    [CHZGlobalInstance shareInstance].gotoWitchView = 333;
                }else{
                    [CHZGlobalInstance shareInstance].gotoWitchView = 111;
                }
            }
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"请稍后再试"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error);
    }];
    
    
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payMoney.text = [NSString stringWithFormat:@"1年(%@元)",_regM.payMoney];
    self.name.text = _regM.name;
    
    
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
