//
//  CHZLoginViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/2.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZLoginViewController.h"
#import "CHZMainTabBarViewController.h"
#import "CHZUserInfoModel.h"
#import "CHZRegistDelegateTableViewController.h"
#import "CHZNavigationController.h"
#import "CHZMapModel.h"
#import "CHZRegistTableViewController.h"
#import "CHZPayViewController.h"
#import "CHZRegistModel.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@interface CHZLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;


@property (nonatomic, strong)NSMutableArray *urlArr;
@property (nonatomic, strong)NSArray *mapArr;

@property (nonatomic, copy)NSString *forgetPwdShowtext;
@property (nonatomic, copy)NSString *forgetPwdPhone;


@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@end

@implementation CHZLoginViewController

- (NSArray *)mapArr{
    if (!_mapArr) {
        _mapArr = [NSArray array];
    }
    return _mapArr;
}

- (NSMutableArray *)urlArr{
    if (!_urlArr) {
        _urlArr = [NSMutableArray array];
    }
    return _urlArr;
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

- (IBAction)registBtnClick {
    //跳到注册页
    HZLog(@"regist");
    CHZRegistTableViewController *reDeVC = [[CHZRegistTableViewController alloc] init];
    reDeVC.imgUrls = self.urlArr;
    CHZNavigationController *nav = [[CHZNavigationController alloc] initWithRootViewController:reDeVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    
}
- (IBAction)loginBtnClick {
    if (self.accountTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        return;
    }
    if (self.passwordTF.text == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = self.accountTF.text;
    params[@"password"] = self.passwordTF.text;
    
    
    [self.mgr POST:API_LOGIN parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        HZLog(@"%@",responseObject);
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"id"] != [NSNull null] && responseObject[@"token"] != [NSNull null]) {
                NSString *idStr = responseObject[@"id"];
                NSString *token = responseObject[@"token"];
                [CHZUserDefaults setObject:idStr forKey:@"userId"];
                [CHZUserDefaults setObject:token forKey:@"token"];
                [CHZUserDefaults setObject:self.accountTF.text forKey:@"userName"];
                [CHZUserDefaults setObject:self.passwordTF.text forKey:@"userPwd"];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[CHZMainTabBarViewController alloc] init];
                
                [self getUserInfo];
            }
        }else if (402 == [responseObject[@"code"] integerValue]){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }else if (403 == [responseObject[@"code"] integerValue]){
            
            [CHZUserDefaults setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [CHZUserDefaults setObject:responseObject[@"data"][@"id"] forKey:@"userId"];
            CHZRegistModel *regM = [[CHZRegistModel alloc] initWithDict:responseObject[@"data"]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * PH = [UIAlertAction actionWithTitle:@"进入支付页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                CHZPayViewController *payVC = [CHZPayViewController shareInstance];
                payVC.anyViewRegM = regM;
                payVC.isLoginView = YES;
                CHZNavigationController *nav = [[CHZNavigationController alloc] initWithRootViewController:payVC];
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
                
            }];
            
            [alert addAction:PH];
            
            alert.popoverPresentationController.sourceView = self.view;
            alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
            
        }else if(404 == [responseObject[@"code"] integerValue]){
            
            [CHZUserDefaults setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [CHZUserDefaults setObject:responseObject[@"data"][@"id"] forKey:@"userId"];
            CHZRegistModel *regM = [[CHZRegistModel alloc] initWithDict:responseObject[@"data"]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * PH = [UIAlertAction actionWithTitle:@"进入支付页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                CHZPayViewController *payVC = [CHZPayViewController shareInstance];
                payVC.anyViewRegM = regM;
                payVC.isLoginView = YES;
                CHZNavigationController *nav = [[CHZNavigationController alloc] initWithRootViewController:payVC];
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
                        
            }];
            
            [alert addAction:PH];
            
            alert.popoverPresentationController.sourceView = self.view;
            alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
            [self presentViewController:alert animated:YES completion:^{
                
            }];

        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"登陆失败,请稍后再试"];

        HZLog(@"%@===%@",error.localizedDescription,error.description);
    }];
}

//获取用户数据
- (void)getUserInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    
    [self.mgr POST:API_USERINFO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"调用个人信息接口成功");
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != nil && responseObject[@"data"] !=[NSNull null]) {
                CHZUserInfoModel *userInfo = [[CHZUserInfoModel alloc] initWithDict:responseObject[@"data"]];
                [NSKeyedArchiver archiveRootObject:userInfo toFile:CHZAccountFile];
            }
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField.tag == 1) {
        [self loginBtnClick];
    }
    
    return YES;
}



- (IBAction)registDelegate {
    HZLog(@"regist");
    CHZRegistDelegateTableViewController *reDeVC = [[CHZRegistDelegateTableViewController alloc] init];
    reDeVC.imgUrls = self.urlArr;
    CHZNavigationController *nav = [[CHZNavigationController alloc] initWithRootViewController:reDeVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (IBAction)forgetPwd {
    if (_forgetPwdShowtext) {
        [self EditAlertShow:self.forgetPwdShowtext];
    }else{
        [self forgetPwdPost:YES];
    }
    
}

- (void)EditAlertShow:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * TP = [UIAlertAction actionWithTitle:@"电话联系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_forgetPwdPhone]];
        [[UIApplication sharedApplication] openURL:url];

    }];
    UIAlertAction *CA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:TP];
    [alert addAction:CA];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}


- (void)forgetPwdPost:(BOOL)isGet{
    HZLog(@"forgetPwd");
    if (isGet) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
    }
    [self.mgr POST:API_FORGETPWD parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (200 == [responseObject[@"code"] integerValue]) {
            [SVProgressHUD dismiss];
            _forgetPwdShowtext = responseObject[@"message"];
            _forgetPwdPhone = responseObject[@"tel"];
            if (isGet) {
                [self forgetPwd];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([CHZUserDefaults objectForKey:@"registUserName"]) {
        self.accountTF.text = [CHZUserDefaults objectForKey:@"registUserName"];
    }else{
        NSString *nameStr = [CHZUserDefaults objectForKey:@"userName"];
        if (nameStr) {
            self.accountTF.text = nameStr;
        }
    }
    
    self.passwordTF.delegate = self;
    self.accountTF.delegate = self;
    //获取轮播图片
    [self getRegImgList];
    //获取密码提醒
    [self forgetPwdPost:NO];
    
    // 点击键盘回收
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardhide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    HZLog(@"删除监听");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//点击事件
-(void)keyboardhide:(UITapGestureRecognizer *)tap
{
    [self.accountTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

#pragma --mark登陆轮播图
- (void)getRegImgList{
    [self.mgr POST:API_REGISTVIEWIMGLIST parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HZLog(@"注册轮播图");
        if (responseObject && responseObject != nil) {
            for (NSDictionary *dict in responseObject) {
                NSString *urlStr = dict[@"url"];
                if (urlStr) {
                    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",API_MAIN,urlStr];
                    [self.urlArr addObject:imgUrl];
                }
            }
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"注册轮播图%@",error);
    }];
}

#pragma --mark 获取地点
- (void)getMapAddress{
    
    [self.mgr POST:API_MAP parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HZLog(@"获取地址");
        if (responseObject && responseObject != nil) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in responseObject) {
                CHZMapModel *map = [[CHZMapModel alloc] initWithDict:dict];
                [tempArr addObject:map];
            }
            
            self.mapArr = tempArr;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"注册轮播图%@",error);
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
