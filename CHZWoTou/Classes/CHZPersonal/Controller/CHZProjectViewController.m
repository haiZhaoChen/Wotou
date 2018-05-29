//
//  CHZProjectViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZProjectViewController.h"
#import "CHZProjectModel.h"
#import "CHZProjectImgSetViewController.h"

@interface CHZProjectViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) UITextField *title1;
@property (weak, nonatomic) UITextField *title2;
@property (weak, nonatomic) UITextField *title3;
@property (weak, nonatomic) UITextField *title4;
@property (weak, nonatomic) UIImageView *img1;
@property (weak, nonatomic) UIImageView *img2;
@property (weak, nonatomic) UIImageView *img3;
@property (weak, nonatomic) UIImageView *img4;
@property (weak, nonatomic)UIButton *commitBtn;

@property (nonatomic, strong)UIImage *imgPro1;
@property (nonatomic, strong)UIImage *imgPro2;
@property (nonatomic, strong)UIImage *imgPro3;
@property (nonatomic, strong)UIImage *imgPro4;

@property (nonatomic, copy)NSString *imgName1;
@property (nonatomic, copy)NSString *imgName2;
@property (nonatomic, copy)NSString *imgName3;
@property (nonatomic, copy)NSString *imgName4;

@property (nonatomic, assign)BOOL isImgSet1;
@property (nonatomic, assign)BOOL isImgSet2;
@property (nonatomic, assign)BOOL isImgSet3;
@property (nonatomic, assign)BOOL isImgSet4;

@property (nonatomic, strong)NSMutableDictionary *saveValues;
@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (nonatomic, assign)BOOL isNeedUpdata;

@property (nonatomic, assign)NSUInteger whichTag;

@end

@implementation CHZProjectViewController

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
    self.navigationItem.title = @"经营项目";
    // Do any additional setup after loading the view from its nib.
    [self setupAllView];
    
    // 点击键盘回收
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardhide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
//点击事件
-(void)keyboardhide:(UITapGestureRecognizer *)tap
{
    [self.title1 resignFirstResponder];
    [self.title2 resignFirstResponder];
    [self.title3 resignFirstResponder];
    [self.title4 resignFirstResponder];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.proModel) {
        self.title1.text = self.proModel.xm_title1;
        self.title2.text = self.proModel.xm_title2;
        self.title3.text = self.proModel.xm_title3;
        self.title4.text = self.proModel.xm_title4;
        
        [self.img1 sd_setImageWithURL:[NSURL URLWithString:self.proModel.xm_img1] placeholderImage:[UIImage imageNamed:@"picture_128"]];
        [self.img2 sd_setImageWithURL:[NSURL URLWithString:self.proModel.xm_img2] placeholderImage:[UIImage imageNamed:@"picture_128"]];
        [self.img3 sd_setImageWithURL:[NSURL URLWithString:self.proModel.xm_img3] placeholderImage:[UIImage imageNamed:@"picture_128"]];
        [self.img4 sd_setImageWithURL:[NSURL URLWithString:self.proModel.xm_img4] placeholderImage:[UIImage imageNamed:@"picture_128"]];
        
        
    }
}

- (void)selectImg:(UIButton *)btn{
    self.whichTag = btn.tag;
    [self EditAlertShow];
    
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
            self.imgPro1 = image;
            self.img1.image = image;
            break;
        case 2:
            self.imgPro2 = image;
            self.img2.image = image;
            break;
        case 3:
            self.imgPro3 = image;
            self.img3.image = image;
            break;
        case 4:
            self.imgPro4 = image;
            self.img4.image = image;
            break;
        default:
            break;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)setImgPro1:(UIImage *)imgPro1{
    [self saveImgSet:1 andImg:imgPro1];
}

- (void)setImgPro2:(UIImage *)imgPro2{
    [self saveImgSet:2 andImg:imgPro2];
}

-(void)setImgPro3:(UIImage *)imgPro3{
    [self saveImgSet:3 andImg:imgPro3];
}
- (void)setImgPro4:(UIImage *)imgPro4{
    [self saveImgSet:4 andImg:imgPro4];
}

//保存照片
- (void)saveImgSet:(NSUInteger)tag andImg:(UIImage *)img{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"type"] = [NSString stringWithFormat:@"%lu",(unsigned long)tag];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在上传"];
    
    [self.mgr POST:API_PROJECTIMGUP parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data1 = UIImageJPEGRepresentation(img, 0.000001);
        NSString *filename1 = [NSString stringWithFormat:@"img.jpg"];
        [formData appendPartWithFileData:data1 name:[NSString stringWithFormat:@"xm_img%lu",(unsigned long)tag] fileName:filename1 mimeType:@"image/jpeg"];
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
                    self.isImgSet1 = YES;
                    break;
                case 2:
                    self.imgName2 = responseObject[@"data"];
                    self.isImgSet2 = YES;
                    break;
                    
                case 3:
                    self.imgName3 = responseObject[@"data"];
                    self.isImgSet3 = YES;
                    break;
                case 4:
                    self.imgName4 = responseObject[@"data"];
                    self.isImgSet4 = YES;
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




//- (void)selectImg:(UIButton *)btn{
//    
//    
//
//    CHZProjectImgSetViewController *proImgVC = [[CHZProjectImgSetViewController alloc] init];
//    proImgVC.type = btn.tag;
//    [proImgVC returnText:^(NSString *showText) {
//        [self.saveValues setValue:showText forKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
//        NSString *imgKey = [NSString stringWithFormat:@"imgSet%lu",(unsigned long)btn.tag];
//        UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgKey];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            switch (btn.tag) {
//                case 1:
//                    
//                    self.img1.image = img;
//                    break;
//                case 2:
//                    self.img2.image = img;
//                    break;
//                case 3:
//                    self.img3.image = img;
//                    break;
//                case 4:
//                    self.img4.image = img;
//                    break;
//                    
//                default:
//                    break;
//                    
//            }
//        });
//    }];
//    switch (btn.tag) {
//        case 1:
//            proImgVC.imgNormal = self.proModel.xm_img1;
//            break;
//        case 2:
//            proImgVC.imgNormal = self.proModel.xm_img2;
//            break;
//        case 3:
//            proImgVC.imgNormal = self.proModel.xm_img3;
//            break;
//        case 4:
//            proImgVC.imgNormal = self.proModel.xm_img4;
//            break;
//            
//        default:
//            break;
//    
//    }
//    [self.navigationController pushViewController:proImgVC animated:YES];
//}




- (void)setupAllView{
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth *0.06, 10, kScreenWidth *0.4, kScreenWidth *0.48)];
    UITextField *titleTF1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView1.width, 30)];
    titleTF1.textAlignment = NSTextAlignmentCenter;
    titleTF1.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    titleTF1.borderStyle = UITextBorderStyleNone;
    titleTF1.placeholder = @"图片名字";
    titleTF1.font = [UIFont systemFontOfSize:15];
    
    self.title1 = titleTF1;
    
    
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
    
//    UILabel *wrongLable1 = [[UILabel alloc] initWithFrame:CGRectMake(bgView1.width-95 - 47, CGRectGetMaxY(imgView1.frame), 45, 28)];
//    wrongLable1.text = @"失败";
    
    
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
    UITextField *titleTF2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView2.width, 30)];
    titleTF2.textAlignment = NSTextAlignmentCenter;
    titleTF2.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    titleTF2.borderStyle = UITextBorderStyleNone;
    titleTF2.placeholder = @"图片名字";
    titleTF2.font = [UIFont systemFontOfSize:15];
    
    self.title2 = titleTF2;
    
    
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
    UITextField *titleTF3 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView3.width, 30)];
    titleTF3.textAlignment = NSTextAlignmentCenter;
    titleTF3.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    titleTF3.borderStyle = UITextBorderStyleNone;
    titleTF3.placeholder = @"图片名字";
    titleTF3.font = [UIFont systemFontOfSize:15];
    
    self.title3 = titleTF3;
    
    
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
    
    
    /************************444444*************************/
    
    UIView *bgView4 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth *0.54, CGRectGetMaxY(bgView2.frame)+5, kScreenWidth *0.4, kScreenWidth *0.48)];
    UITextField *titleTF4 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView4.width, 30)];
    titleTF4.textAlignment = NSTextAlignmentCenter;
    titleTF4.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    titleTF4.borderStyle = UITextBorderStyleNone;
    titleTF4.placeholder = @"图片名字";
    titleTF4.font = [UIFont systemFontOfSize:15];
    
    self.title4 = titleTF4;
    
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF4.frame)+2, bgView4.width, 1)];
    line4.backgroundColor = [UIColor grayColor];
    
    UIImageView *imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTF4.frame)+4, bgView4.width, bgView4.width *0.68)];
    self.img4 = imgView4;
    
    UIButton *selectBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn4.frame = CGRectMake(bgView4.width-95, CGRectGetMaxY(imgView4.frame)+3, 90, 28);
    selectBtn4.backgroundColor = [UIColor orangeColor];
    selectBtn4.layer.masksToBounds = YES;
    selectBtn4.layer.cornerRadius = 5;
    selectBtn4.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectBtn4 setTitleColor:CHZRGBColor(222, 222, 222) forState:UIControlStateHighlighted];
    [selectBtn4 setTitle:@"选择图片" forState:UIControlStateNormal];
    [selectBtn4 setImage:[UIImage imageNamed:@"upcloud"] forState:UIControlStateNormal];
    selectBtn4.tag = 4;
    [selectBtn4 addTarget:self action:@selector(selectImg:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *warningLB4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtn4.frame)+2, bgView4.width, 18)];
    warningLB4.font = [UIFont systemFontOfSize:11];
    warningLB4.textAlignment = NSTextAlignmentRight;
    warningLB4.text = @"!请上传手机横版照片";
    warningLB4.textColor = [UIColor darkGrayColor];
    
    [bgView4 addSubview:warningLB4];
    [bgView4 addSubview:line4];
    [bgView4 addSubview:selectBtn4];
    [bgView4 addSubview:imgView4];
    [bgView4 addSubview:titleTF4];
    
    CGRect bgView4Frame4 = bgView4.frame;
    bgView4Frame4.size.height = CGRectGetMaxY(warningLB4.frame)+5;
    bgView4.frame = bgView4Frame4;
    
    
    [self.view addSubview:bgView4];
    
    /*********************commit***********************/
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    commitBtn.frame = CGRectMake((kScreenWidth -120) *0.5, CGRectGetMaxY(bgView4.frame) +8, 120, 35);
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
    imgView4.image = [UIImage imageNamed:@"picture_128"];
    
    [self.view addSubview:commitBtn];
    
    
}

- (void)commitBtnClick{
    //提交数据
    if (self.title1.text.length == 0 || self.title2.text.length == 0 ||
        self.title3.text.length == 0|| self.title4.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写空白的标题"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] =  params[@"id"];
    params[@"xm_title1"] = self.title1.text;
    params[@"xm_title2"] = self.title2.text;
    params[@"xm_title3"] = self.title3.text;
    params[@"xm_title4"] = self.title4.text;
    
    if (self.isImgSet1) {
        params[@"xm_img1"] = self.imgName1;
    }else{
        if (!self.proModel.xm_img1.length) {
            [SVProgressHUD showErrorWithStatus:@"第1个项目未传图片"];
            return;
        }
        params[@"xm_img1"] = @"";
    }
    if (self.isImgSet2) {
        params[@"xm_img2"] = self.imgName2;
    }else{
        if (!self.proModel.xm_img2.length) {
            [SVProgressHUD showErrorWithStatus:@"第2个项目未传图片"];
            return;
        }
        params[@"xm_img2"] = @"";
    }
    
    if (self.isImgSet3) {
        params[@"xm_img3"] = self.imgName3;
    }else{
        if (!self.proModel.xm_img3.length) {
            [SVProgressHUD showErrorWithStatus:@"第3个项目未传图片"];
            return;
        }
        params[@"xm_img3"] = @"";
    }
    if (self.isImgSet4) {
        params[@"xm_img1"] = self.imgName4;
    }else{
        if (!self.proModel.xm_img4.length) {
            [SVProgressHUD showErrorWithStatus:@"第4个项目未传图片"];
            return;
        }
        params[@"xm_img4"] = @"";
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在提交"];
    
    [self.mgr POST:API_PROJECTCOMMIT parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (200 == [responseObject[@"code"] integerValue]) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            self.isNeedUpdata = YES;

            self.isImgSet1 = NO;
            self.isImgSet2 = NO;
            self.isImgSet3 = NO;
            self.isImgSet4 = NO;
            
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (int i = 1; i<5; i++) {
        NSString *imgKey = [NSString stringWithFormat:@"imgSet%d",i];
        [[SDImageCache sharedImageCache] removeImageForKey:imgKey fromDisk:YES];
    }
    
    if (self.returnUpdataBlock != nil) {

        self.returnUpdataBlock(self.isNeedUpdata);
        
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}




- (void)returnText:(ReturnUpdataBlock)block{
    self.returnUpdataBlock = block;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
