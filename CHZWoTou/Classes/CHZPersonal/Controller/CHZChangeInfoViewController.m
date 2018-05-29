//
//  CHZChangeInfoViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZChangeInfoViewController.h"
#import "CHZUserInfoModel.h"
#import "Util.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@interface CHZChangeInfoViewController ()

@property (nonatomic,strong)AFHTTPSessionManager *mgr;
@property (weak, nonatomic) IBOutlet UILabel *warningName;

@end

@implementation CHZChangeInfoViewController

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
    self.navigationItem.title = self.theName;
    self.view.backgroundColor = CHZGlobalBg;
    self.theTextF.text = self.theText;
    self.warningName.text = self.theWarning;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(sendMessageClick)];
    
    self.navigationItem.rightBarButtonItem.enabled= NO;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:CHZRGBColor(203, 203, 233),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    
    // 通知
    [CHZNotificationCenter addObserver:self selector:@selector(textViewChange:) name:UITextFieldTextDidChangeNotification object:self.theTextF];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMessageClick{
    switch (self.type) {
        case 1:
            //昵称
            if (self.theTextF.text.length <2 || self.theTextF.text.length >7) {
                [SVProgressHUD showInfoWithStatus:@"昵称设置\n两个字符到六个字符之间"];
                return;
            }
            break;
        case 2:
            //电子邮箱
            if (![Util validateEmail:self.theTextF.text]) {
                [SVProgressHUD showInfoWithStatus:@"邮箱地址不正确"];
                return;
            }
            break;
        case 6:
            //URL
            if (![Util checkURL:self.theTextF.text]) {
                [SVProgressHUD showInfoWithStatus:@"网址不正确"];
                return;
            }
//            else{
//                self.theTextF.text = [NSString stringWithFormat:@"%@%@",@"http://",self.theTextF.text];
//            }
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] = params[@"id"];
    params[@"info"] = self.theTextF.text;
    params[@"type"] = [NSString stringWithFormat:@"%lu",(unsigned long)self.type];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [self.mgr POST:API_UPDATEUSERINFO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (200 == [responseObject[@"code"] integerValue]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            //修改数据
            [self getUserInfo];
            
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
        [SVProgressHUD showErrorWithStatus:@"修改失败，请稍后再试"];
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

- (void)dealloc{
    HZLog(@"删除监听");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewChange:(NSNotificationCenter *)noc{
    self.navigationItem.rightBarButtonItem.enabled =![self.theTextF.text isEqualToString:self.theText];
    if (self.theTextF.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if (self.navigationItem.rightBarButtonItem.enabled) {
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }else{
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:CHZRGBColor(203, 203, 233),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
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
