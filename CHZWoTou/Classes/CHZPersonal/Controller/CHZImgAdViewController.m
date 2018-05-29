//
//  CHZImgAdViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZImgAdViewController.h"
#import "CHZADImgModel.h"

@interface CHZImgAdViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) UIImageView *img1;
@property (weak, nonatomic) UIImageView *img2;
@property (weak, nonatomic) UIImageView *img3;

@property (strong, nonatomic) UIImage *adImg1;
@property (strong, nonatomic) UIImage *adImg2;
@property (strong, nonatomic) UIImage *adImg3;

@property (nonatomic, copy)NSString *imgName1;
@property (nonatomic, copy)NSString *imgName2;
@property (nonatomic, copy)NSString *imgName3;

@property (nonatomic, assign)BOOL adImg1Ok;
@property (nonatomic, assign)BOOL adImg2Ok;
@property (nonatomic, assign)BOOL adImg3Ok;

@property (weak, nonatomic)UIButton *commitBtn;

@property (nonatomic, strong)NSMutableDictionary *saveValues;
@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (nonatomic, assign)BOOL isNeedUpdata;

@property (nonatomic, assign)NSUInteger whichTag;
@end

@implementation CHZImgAdViewController

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}

- (NSMutableDictionary *)saveValues{
    if (!_saveValues) {
        _saveValues = [NSMutableDictionary dictionary];
    }
    
    return _saveValues;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"轮播管理";
    // Do any additional setup after loading the view from its nib.
    [self setupAllView];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.adModel) {
        
        [self.img1 sd_setImageWithURL:[NSURL URLWithString:self.adModel.ad_img1] placeholderImage:[UIImage imageNamed:@"picture_128"]];
        [self.img2 sd_setImageWithURL:[NSURL URLWithString:self.adModel.ad_img2] placeholderImage:[UIImage imageNamed:@"picture_128"]];
        [self.img3 sd_setImageWithURL:[NSURL URLWithString:self.adModel.ad_img3] placeholderImage:[UIImage imageNamed:@"picture_128"]];
        
    }
}

#pragma --mark 点击添加图片
- (void)selectImg:(UIButton *)btn{
    self.whichTag = btn.tag;
    [self EditAlertShow];
}

- (void)setupAllView{
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth *0.06, 10, kScreenWidth *0.4, kScreenWidth *0.48)];
    UILabel *titleTF1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView1.width, 30)];
//    titleTF1.textAlignment = NSTextAlignmentCenter;
//    titleTF1.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    titleTF1.borderStyle = UITextBorderStyleNone;
//    titleTF1.placeholder = @"图片名字";
    titleTF1.text = @"上传轮播图片1";
    titleTF1.textAlignment = NSTextAlignmentCenter;
    titleTF1.font = [UIFont systemFontOfSize:15];
    
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF1.frame)+2, bgView1.width, 1)];
    line1.backgroundColor = [UIColor grayColor];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF1.frame)+4, bgView1.width, bgView1.width *0.68)];
    self.img1 = imgView1;
    
    UIButton *selectBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn1.frame = CGRectMake(bgView1.width-95, CGRectGetMaxY(imgView1.frame)+3, 90, 28);
    selectBtn1.backgroundColor = [UIColor orangeColor];
    selectBtn1.layer.masksToBounds = YES;
    selectBtn1.layer.cornerRadius = 5;
    selectBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectBtn1 setTitleColor:CHZRGBColor(222, 222, 222) forState:UIControlStateHighlighted];
    [selectBtn1 setTitle:@"选择图片" forState:UIControlStateNormal];
    [selectBtn1 setImage:[UIImage imageNamed:@"upcloud"] forState:UIControlStateNormal];
    selectBtn1.tag = 1;
    [selectBtn1 addTarget:self action:@selector(selectImg:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *warningLB1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtn1.frame)+2, bgView1.width, 18)];
    warningLB1.font = [UIFont systemFontOfSize:11];
    warningLB1.textAlignment = NSTextAlignmentRight;
    warningLB1.text = @"!请上传手机横版照片";
    warningLB1.textColor = [UIColor darkGrayColor];
    
    [bgView1 addSubview:warningLB1];
    [bgView1 addSubview:line1];
    [bgView1 addSubview:selectBtn1];
    [bgView1 addSubview:imgView1];
    [bgView1 addSubview:titleTF1];
    
    CGRect bgView1Frame1 = bgView1.frame;
    bgView1Frame1.size.height = CGRectGetMaxY(warningLB1.frame)+5;
    bgView1.frame = bgView1Frame1;
    
    
    [self.view addSubview:bgView1];
    
    /************************2222222*************************/
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth *0.54, 10, kScreenWidth *0.4, kScreenWidth *0.48)];
    UILabel *titleTF2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView2.width, 30)];
    titleTF2.textAlignment = NSTextAlignmentCenter;
    titleTF2.text = @"上传轮播图片2";
//    titleTF2.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    titleTF2.borderStyle = UITextBorderStyleNone;
//    titleTF2.placeholder = @"图片名字";
    titleTF2.font = [UIFont systemFontOfSize:15];
    
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF2.frame)+2, bgView2.width, 1)];
    line2.backgroundColor = [UIColor grayColor];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF2.frame)+4, bgView2.width, bgView2.width *0.68)];
    self.img2 = imgView2;
    
    UIButton *selectBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn2.frame = CGRectMake(bgView2.width-95, CGRectGetMaxY(imgView2.frame)+3, 90, 28);
    selectBtn2.backgroundColor = [UIColor orangeColor];
    selectBtn2.layer.masksToBounds = YES;
    selectBtn2.layer.cornerRadius = 5;
    selectBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectBtn2 setTitleColor:CHZRGBColor(222, 222, 222) forState:UIControlStateHighlighted];
    [selectBtn2 setTitle:@"选择图片" forState:UIControlStateNormal];
    [selectBtn2 setImage:[UIImage imageNamed:@"upcloud"] forState:UIControlStateNormal];
    selectBtn2.tag = 2;
    [selectBtn2 addTarget:self action:@selector(selectImg:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *warningLB2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtn2.frame)+2, bgView2.width, 18)];
    warningLB2.font = [UIFont systemFontOfSize:11];
    warningLB2.textAlignment = NSTextAlignmentRight;
    warningLB2.text = @"!请上传手机横版照片";
    warningLB2.textColor = [UIColor darkGrayColor];
    
    [bgView2 addSubview:warningLB2];
    [bgView2 addSubview:line2];
    [bgView2 addSubview:selectBtn2];
    [bgView2 addSubview:imgView2];
    [bgView2 addSubview:titleTF2];
    
    CGRect bgView2Frame2 = bgView2.frame;
    bgView2Frame2.size.height = CGRectGetMaxY(warningLB2.frame)+5;
    bgView2.frame = bgView2Frame2;
    
    
    [self.view addSubview:bgView2];
    
    /************************3333333*************************/
    UIView *longLine = [[UIView alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(bgView2.frame)+2, kScreenWidth -4, 1)];
    longLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:longLine];
    
    
    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth *0.06, CGRectGetMaxY(bgView2.frame)+8, kScreenWidth *0.4, kScreenWidth *0.48)];
    UILabel *titleTF3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView3.width, 30)];
    titleTF3.textAlignment = NSTextAlignmentCenter;
//    titleTF3.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    titleTF3.borderStyle = UITextBorderStyleNone;
//    titleTF3.placeholder = @"图片名字";
    titleTF3.text = @"上传轮播图片3";
    titleTF3.font = [UIFont systemFontOfSize:15];
    
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF3.frame)+2, bgView3.width, 1)];
    line3.backgroundColor = [UIColor grayColor];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF3.frame)+4, bgView3.width, bgView3.width *0.68)];
    self.img3 = imgView3;
    
    UIButton *selectBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn3.frame = CGRectMake(bgView3.width-95, CGRectGetMaxY(imgView3.frame)+3, 90, 28);
    selectBtn3.backgroundColor = [UIColor orangeColor];
    selectBtn3.layer.masksToBounds = YES;
    selectBtn3.layer.cornerRadius = 5;
    selectBtn3.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectBtn3 setTitleColor:CHZRGBColor(222, 222, 222) forState:UIControlStateHighlighted];
    [selectBtn3 setTitle:@"选择图片" forState:UIControlStateNormal];
    [selectBtn3 setImage:[UIImage imageNamed:@"upcloud"] forState:UIControlStateNormal];
    selectBtn3.tag = 3;
    [selectBtn3 addTarget:self action:@selector(selectImg:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *warningLB3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtn3.frame)+2, bgView3.width, 18)];
    warningLB3.font = [UIFont systemFontOfSize:11];
    warningLB3.textAlignment = NSTextAlignmentRight;
    warningLB3.text = @"!请上传手机横版照片";
    warningLB3.textColor = [UIColor darkGrayColor];
    
    [bgView3 addSubview:warningLB3];
    [bgView3 addSubview:line3];
    [bgView3 addSubview:selectBtn3];
    [bgView3 addSubview:imgView3];
    [bgView3 addSubview:titleTF3];
    
    CGRect bgView3Frame3 = bgView3.frame;
    bgView3Frame3.size.height = CGRectGetMaxY(warningLB3.frame)+5;
    bgView3.frame = bgView3Frame3;
    
    
    [self.view addSubview:bgView3];
    
    
    
    
    /*********************commit***********************/
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    commitBtn.frame = CGRectMake((kScreenWidth -120) *0.5, CGRectGetMaxY(bgView3.frame) +8, 120, 35);
    commitBtn.backgroundColor = [UIColor orangeColor];
    [commitBtn setTitle:@"更新项目" forState:UIControlStateNormal];
    [commitBtn setTitleColor:CHZRGBColor(222, 222, 222) forState:UIControlStateHighlighted];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 5;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.commitBtn = commitBtn;
    
    imgView1.image = [UIImage imageNamed:@"picture_128"];
    imgView2.image = [UIImage imageNamed:@"picture_128"];
    imgView3.image = [UIImage imageNamed:@"picture_128"];
    
    [self.view addSubview:commitBtn];
    
    
}



#pragma --mark提交所有数据
- (void)commitBtnClick{
    
    if (!self.adImg1Ok && !self.adImg2Ok && !self.adImg3Ok) {
        [SVProgressHUD showErrorWithStatus:@"未添加新的轮播图片"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] =  params[@"id"];
    if (self.imgName1) {
        params[@"ad_img1"] = self.imgName1;
    }else{
        if (!self.adModel.ad_img1.length) {
            [SVProgressHUD showErrorWithStatus:@"第1个项目未传图片"];
            return;
        }
        params[@"ad_img1"] = @"";
    }
    if (self.imgName2) {
        params[@"ad_img2"] = self.imgName2;
    }else{
        if (!self.adModel.ad_img2.length) {
            [SVProgressHUD showErrorWithStatus:@"第2个项目未传图片"];
            return;
        }
        params[@"ad_img2"] = @"";
    }
    if (self.imgName3) {
        params[@"ad_img3"] = self.imgName3;
    }else{
        if (!self.adModel.ad_img3.length) {
            [SVProgressHUD showErrorWithStatus:@"第3个项目未传图片"];
            return;
        }
        params[@"ad_img3"] = @"";
    }
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在提交"];
    
    [self.mgr POST:API_ADCOMMIT parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (200 == [responseObject[@"code"] integerValue]) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            self.isNeedUpdata = YES;
            self.adImg1Ok = NO;
            self.adImg2Ok = NO;
            self.adImg3Ok = NO;
            
            
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
        [SVProgressHUD showErrorWithStatus:@"提交失败，请稍后再试"];
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
    self.navigationItem.rightBarButtonItem.enabled = YES;
    UIImage *image = info[UIImagePickerControllerEditedImage];
    switch (self.whichTag) {
        case 1:
            self.adImg1 = image;
            self.img1.image = image;
            break;
        case 2:
            self.adImg2 = image;
            self.img2.image = image;
            break;
        case 3:
            self.adImg3 = image;
            self.img3.image = image;
            break;
            
        default:
            break;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)setAdImg1:(UIImage *)adImg1{
    _adImg1 = adImg1;
    [self saveImgSet:1 andImg:adImg1];
    
}

- (void)setAdImg2:(UIImage *)adImg2{
    _adImg2 = adImg2;
    [self saveImgSet:2 andImg:adImg2];
    
}

-(void)setAdImg3:(UIImage *)adImg3{
    _adImg3 = adImg3;
    [self saveImgSet:3 andImg:adImg3];
}


//保存照片
- (void)saveImgSet:(NSUInteger)tag andImg:(UIImage *)img{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"type"] = [NSString stringWithFormat:@"%lu",(unsigned long)tag];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在上传"];
    
    [self.mgr POST:API_ADIMGUP parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data1 = UIImageJPEGRepresentation(img, 0.000001);
        NSString *filename1 = [NSString stringWithFormat:@"img.jpg"];
        [formData appendPartWithFileData:data1 name:[NSString stringWithFormat:@"ad_img%lu",(unsigned long)tag] fileName:filename1 mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        /*
         Code 200 message 修改头像成功 data 新地址
         Code 400 message 修改失败，稍后重试
         Code 404 message 没有选择图片
         
         */
        if (200 == [responseObject[@"code"] integerValue]) {
            [SVProgressHUD showSuccessWithStatus:@"上传图片成功"];
            switch (tag) {
                case 1:
                    self.imgName1 = responseObject[@"data"];
                    self.adImg1Ok = YES;
                    break;
                case 2:
                    self.imgName2 = responseObject[@"data"];
                    self.adImg2Ok = YES;
                    break;

                case 3:
                    self.imgName3 = responseObject[@"data"];
                    self.adImg3Ok = YES;
                    break;

                    
                default:
                    break;
            }
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }else{
            [SVProgressHUD showErrorWithStatus:@"失败！请重新选择"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败，请稍后再试"];
    }];
    
}




- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.returnUpdataBlock != nil) {
        
        self.returnUpdataBlock(self.isNeedUpdata);
        
        
    }
}


- (void)returnText:(ReturnUpdataBlock)block{
    self.returnUpdataBlock = block;
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
