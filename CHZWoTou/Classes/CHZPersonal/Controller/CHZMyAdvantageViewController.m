//
//  CHZMyAdvantageViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/21.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZMyAdvantageViewController.h"

@interface CHZMyAdvantageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textPosition;


@end

@implementation CHZMyAdvantageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的优势";
    
}
- (IBAction)commitBtn:(id)sender {
    if (self.textPosition.text.length >0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"uid"] = params[@"id"];
        params[@"youshi"] = self.textPosition.text;
        
        
        // 1.创建请求管理对象
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:@"正在提交"];
        [mgr POST:API_YOUSHI parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            if (200 == [responseObject[@"code"] integerValue]) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
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
            [SVProgressHUD showErrorWithStatus:@"提交失败,请稍后再试"];
        }];

    }else{
        [SVProgressHUD showInfoWithStatus:@"编辑信息不能为空"];
    }
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
