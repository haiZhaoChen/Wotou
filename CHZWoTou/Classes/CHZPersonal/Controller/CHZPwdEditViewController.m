//
//  CHZPwdEditViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/8.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZPwdEditViewController.h"
#import "CHZLoginViewController.h"

@interface CHZPwdEditViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *originalPwd;
@property (weak, nonatomic) IBOutlet UITextField *theNewPwd;
@property (weak, nonatomic) IBOutlet UIImageView *isWrongImg;

@property (weak, nonatomic) IBOutlet UITextField *reNewPwd;
@property (nonatomic, assign)BOOL isWrong;

@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@end

@implementation CHZPwdEditViewController

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}


- (IBAction)commitNewPwd {
    
    HZLog(@"提交新密码");
    if (self.originalPwd.text.length == 0 || self.theNewPwd.text.length == 0 ||self.reNewPwd.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"必填内容未输入完整"];
        return;
    }
    if (_isWrong) {
        [SVProgressHUD showErrorWithStatus:@"请修改不符合规定的选项"];
        return;
    }
    
    if ([self.originalPwd.text isEqualToString:self.theNewPwd.text]) {
        [SVProgressHUD showErrorWithStatus:@"新密码不能和原始密码相同"];
        return;
    }
    
    if (![self.theNewPwd.text isEqualToString:self.reNewPwd.text]) {
        [SVProgressHUD showErrorWithStatus:@"新密码两次输入不一致"];
        return;
    }
    
    NSString *oriPwd = [CHZUserDefaults objectForKey:@"userPwd"];
    
    if (![self.originalPwd.text isEqualToString:oriPwd]) {
        [SVProgressHUD showErrorWithStatus:@"输入的原始密码有误"];
        return;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在提交..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"password"] = self.theNewPwd.text;
    
    [self.mgr POST:API_PWDCHANGE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        if (200 == [responseObject[@"code"] integerValue]) {
            //重新登陆了
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [CHZUserDefaults setObject:self.Password.text forKey:@"password"];
                [CHZUserDefaults setObject:@"" forKey:@"userPwd"];
                CHZLoginViewController *loginVC = [[CHZLoginViewController alloc] init];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
                
                //退出登陆，清空token
                [CHZUserDefaults setObject:nil forKey:@"token"];
                [CHZUserDefaults setObject:nil forKey:@"userId"];
                //                [MBProgressHUD showNormalMessage:@"请重新登录！"];
                
            });

        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"提交失败，请稍后重试"];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = CHZGlobalBg;
    self.navigationItem.title = @"密码修改";
    
    self.theNewPwd.delegate = self;
    self.originalPwd.delegate = self;
    self.reNewPwd.delegate = self;
    
    // 点击键盘回收
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardhide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (2 == textField.tag) {
        if (textField.text.length >0 && textField.text.length <6) {
            [SVProgressHUD showErrorWithStatus:@"请输入大于六位数的密码"];
            self.isWrong = YES;
            self.isWrongImg.hidden = NO;
            for (int i=0; i<textField.text.length*300; i++) {
                CHZLoginViewController*vc= [[CHZLoginViewController alloc] init];
                vc.view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
            }
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (3 == textField.tag) {
        [self commitNewPwd];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (2 == textField.tag) {
        self.isWrongImg.hidden = YES;
        self.isWrong = NO;
    }

    
}

- (void)keyboardhide:(UITapGestureRecognizer *)tap{
    [self.originalPwd resignFirstResponder];
    [self.theNewPwd resignFirstResponder];
    [self.reNewPwd resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.originalPwd resignFirstResponder];
    [self.theNewPwd resignFirstResponder];
    [self.reNewPwd resignFirstResponder];

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
