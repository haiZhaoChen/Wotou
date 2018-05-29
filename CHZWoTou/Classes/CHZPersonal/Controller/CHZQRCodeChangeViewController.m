//
//  CHZQRCodeChangeViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/7.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZQRCodeChangeViewController.h"
#import "CHZUserInfoModel.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@interface CHZQRCodeChangeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)AFHTTPSessionManager *mgr;


@property (nonatomic, strong)UIImage *imgSet;

@property (nonatomic, weak)UIImageView *imgView;

@end

@implementation CHZQRCodeChangeViewController

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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CHZGlobalBg;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveImgSet)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:CHZRGBColor(253, 253, 233),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self setupAllViews];

}

- (void)setupAllViews{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(KWIDTH *0.1, KHEIGHT*0.15,KWIDTH*0.8 , KWIDTH*0.8);
    imgView.image = [UIImage imageNamed:@"Picture_Clipping"];
    self.imgView = imgView;
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn setSize:CGSizeMake(KWIDTH*0.4, 30)];
    imgBtn.center = imgView.center;
    imgBtn.backgroundColor = [UIColor clearColor];
    
    
    [imgBtn setTitle:@"点击添加图片" forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [imgBtn setTitleColor:CHZRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
    [imgBtn addTarget:self action:@selector(EditAlertShow) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:imgView];
    [self.view addSubview:imgBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//保存照片
- (void)saveImgSet{
    if (self.imgSet) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:@"正在提交"];
        [self.mgr POST:API_QRCODE parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data1 = UIImageJPEGRepresentation(self.imgSet, 0.000001);
            NSString *filename1 = [NSString stringWithFormat:@"iconHeader.jpg"];
            [formData appendPartWithFileData:data1 name:@"qr_code" fileName:filename1 mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            /*
             Code 200 message 修改头像成功 data 新地址
             Code 400 message 修改失败，稍后重试
             Code 404 message 没有选择图片
             
             */
            if (200 == [responseObject[@"code"] integerValue]) {
                [SVProgressHUD showSuccessWithStatus:@"修改二维码成功"];
                //改数据
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
        
        
        //        [[SDImageCache sharedImageCache] storeImage:self.imgSet forKey:@"iconImgSet"];
        //        [SVProgressHUD showSuccessWithStatus:@"已保存"];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [self.navigationController popViewControllerAnimated:YES];
        //        });
    }else{
        [SVProgressHUD showInfoWithStatus:@"请选择图片"];
    }
    
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
        }else if (404 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)EditAlertShow{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:0];
    UIAlertAction * PH = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:ipc animated:YES completion:nil];
        
    }];
    UIAlertAction * TP = [UIAlertAction actionWithTitle:@"现在拍一张" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:ipc animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"无法打开相机"];
        }
    }];
    UIAlertAction *CA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:TP];
    [alert addAction:PH];
    [alert addAction:CA];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 2.取的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.imgSet = image;
    self.imgView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imgView.image = image;
    }];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.imgNormal.length) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgNormal] placeholderImage:[UIImage imageNamed:@"qr_code_128"]];
    }else{
        self.imgView.image = [UIImage imageNamed:@"qr_code_128"];
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
