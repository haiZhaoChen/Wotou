//
//  CHZRegistDelegateTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZRegistDelegateTableViewController.h"
#import "CHZReDelegateTableViewCell.h"
#import "CHZApplyForTableViewCell.h"
#import "CHZimgBtnTableViewCell.h"
#import "CHZImgSetViewController.h"
#import "Util.h"
#import "CHZADListShow.h"
#import "CHZMapModel.h"
#import "CHZMapSelectTableViewCell.h"
#import "ZmjPickView.h"
#import "CHZWebXiYiViewController.h"


#define LASTONE 6

@interface CHZRegistDelegateTableViewController ()<ImgBtnTableViewCellDelegate,ApplyForTableViewCellDelegate,UITextFieldDelegate,MapSelectTableViewCellDelegate>
@property (nonatomic, strong)NSArray *namesArr;

@property (nonatomic,strong)AFHTTPSessionManager *mgr;
//判断是否有选项不符合规定
@property (nonatomic, assign)BOOL isWrong;
//判断省份是否加入
@property (nonatomic, assign)BOOL isMapNone;

@property (nonatomic,copy)NSString *firstImg;
@property (nonatomic,copy)NSString *secImg;
@property (nonatomic,copy)NSString *thirdImg;

@property (nonatomic,copy)NSString *mapAddress;
@property (nonatomic,copy)NSString *mapShi;

@end

@implementation CHZRegistDelegateTableViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = CHZGlobalBg;
    self.navigationItem.title = @"代理商申请";
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.namesArr = @[@"真实姓名",@"手机号码",@"密     码",@"重复密码",@"",@"详细地址",@""];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelRe)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:CHZRGBColor(253, 253, 233),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    
    [self setHeaderView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZReDelegateTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReDelegateCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZimgBtnTableViewCell class]) bundle:nil] forCellReuseIdentifier:ImgBtnCell];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZMapSelectTableViewCell class]) bundle:nil] forCellReuseIdentifier:MapSelectCell];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
    // 3.监听键盘的通知
    [CHZNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [CHZNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)selectMap{
    ZmjPickView *selectMap = [[ZmjPickView alloc] init];
    [selectMap show];
    __weak typeof(self) weakSelf = self;
    selectMap.determineBtnBlock = ^(NSString *shengName, NSString *shiName){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isMapNone = YES;
        CHZMapSelectTableViewCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        cell.mapName.text = [NSString stringWithFormat:@"%@%@",shengName,shiName];
        self.mapAddress = shengName;
        self.mapShi = shiName;
        cell.mapName.textColor = [UIColor blackColor];
        };
    
}

- (void)setHeaderView{
   
    CHZApplyForTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHZApplyForTableViewCell class]) owner:self options:nil] firstObject];
    cell.delegate = self;
    self.tableView.tableFooterView = cell;
}

- (void)setImgUrls:(NSArray *)imgUrls{
    _imgUrls = imgUrls;
    if (self.imgUrls.count) {
        
        CHZADListShow *imgView = [[CHZADListShow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.4)];
        imgView.urlList = self.imgUrls;
        self.tableView.tableHeaderView = imgView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击取消
- (void)cancelRe{
    [self theViewDismiss];
}
#pragma 键盘监听
- (void)keyboardWillShow:(NSNotification *)note{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height*0.3);
        
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)note{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
        
    }];
}


//代理方法：传图片
- (void)postImgBtnClickType:(NSUInteger)type{

    CHZImgSetViewController *imgSetVC = [[CHZImgSetViewController alloc] init];
    imgSetVC.type = type;
    
    [imgSetVC returnIMGUrl:^(NSString *showText) {
        switch (type) {
            case 1:
                self.firstImg = showText;
                break;
            case 2:
                self.secImg = showText;
                break;
            case 3:
                self.thirdImg = showText;
                break;
                
            default:
                break;
        }
    }];
    
    [self.navigationController pushViewController:imgSetVC animated:YES];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.namesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.namesArr[indexPath.row];
    if (LASTONE == indexPath.row) {
        CHZimgBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImgBtnCell forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    if (4 == indexPath.row) {
        CHZMapSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MapSelectCell forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
    CHZReDelegateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReDelegateCell forIndexPath:indexPath];
    if (0 == indexPath.row) {
        cell.conTF.delegate = self;
        cell.conTF.tag = 1;
    }
    if (1 == indexPath.row) {
        cell.conTF.keyboardType = UIKeyboardTypePhonePad;
        cell.conTF.placeholder = @"请输入手机号";
        cell.conTF.delegate = self;
        cell.conTF.tag = 2;
    }
    
    if (2 == indexPath.row) {
        cell.conTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.conTF.secureTextEntry = YES;
        cell.conTF.placeholder = @"大于六位数的密码";
        
    }
    if (3 == indexPath.row) {
        cell.conTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.conTF.secureTextEntry = YES;
        cell.conTF.placeholder = @"再输入一次密码";
    }
    
    cell.titleStr = str;
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (1 == textField.tag) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
//        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"name"] = textField.text;
        [self.mgr POST:API_CHECKAGENTONLY parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (400  == [responseObject[@"code"] integerValue]) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                CHZReDelegateTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
                cell.warningImg.hidden = NO;
                self.isWrong = YES;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    if (2 == textField.tag) {
        if (textField.text.length) {
            if (![Util checkTelNumber:textField.text]) {
                [SVProgressHUD showErrorWithStatus:@"手机号码格式有误"];
                NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
                CHZReDelegateTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
                cell.warningImg.hidden = NO;
                self.isWrong = YES;
            }
        }
        
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (1 == textField.tag) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        CHZReDelegateTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        cell.warningImg.hidden = YES;
        self.isWrong = NO;
    }
    if (2 == textField.tag) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
        CHZReDelegateTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        cell.warningImg.hidden = YES;
        self.isWrong = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


//代理方法：
- (void)applyForBtnClick{
    if (self.isWrong) {
        [SVProgressHUD showErrorWithStatus:@"请修改不符合要求的选项"];
        return;
    }
    CHZReDelegateTableViewCell *cell;
    NSMutableArray *values = [NSMutableArray array];
    
    
    
    for (int i = 0; i< LASTONE; i++) {
        if (i == 4) {
            continue;
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:path];
        
        if (!cell.conTF.text.length) {
            NSString *str = [NSString stringWithFormat:@"%@ 不能为空!",cell.titleStr];
            [SVProgressHUD showErrorWithStatus:str];
            return;
        }
        [values addObject:cell.conTF.text];
    }
    NSString *tempKey = values[2];
    if (tempKey.length <6) {
        [SVProgressHUD showErrorWithStatus:@"请输入大于六位数的密码"];
        return;
    }
    
    if (![values[3] isEqualToString:values[2]]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    if (!self.isMapNone) {
        [SVProgressHUD showErrorWithStatus:@"填写省份地址"];
        return;
    }
    
    
    if (!self.firstImg) {
        [SVProgressHUD showErrorWithStatus:@"请添加身份证正面照片"];
        return;
    }
    if (!self.secImg) {
        [SVProgressHUD showErrorWithStatus:@"请添加身份证背面照片"];
        return;
    }
    
    if (!self.thirdImg) {
        [SVProgressHUD showErrorWithStatus:@"请添加资质照片"];
        return;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在提交..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
//    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
/*   名字：aname
     电话：tel
     密码：password
     地址：address
     身份证正面：id_card1
     身份证背面：id_card2
     公司资质：zizhi
*/
    
    params[@"aname"] = values[0];
    params[@"tel"] = values[1];
    params[@"password"] = values[2];
    params[@"address"] = values[4];
    params[@"id_card1"] = self.firstImg;
    params[@"id_card2"] = self.secImg;
    params[@"zizhi"] = self.thirdImg;
    params[@"provinces"] = self.mapAddress;
    params[@"city"] = self.mapShi;
    
    [self.mgr POST:API_APPLYFORDELE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (200 == [responseObject[@"code"] integerValue]) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self theViewDismiss];
            });
        }else if(400 == [responseObject[@"code"] integerValue]){
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }else{
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"申请失败，请稍后再试"];
        HZLog(@"%@",error);
    }];

}

//页面消失后消除图片缓存
- (void)theViewDismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        [[SDImageCache sharedImageCache] removeImageForKey:@"imgSet1" fromDisk:YES];
        [[SDImageCache sharedImageCache] removeImageForKey:@"imgSet2" fromDisk:YES];
        [[SDImageCache sharedImageCache] removeImageForKey:@"imgSet3" fromDisk:YES];
        
    }];
}
-(void)xieyiWebClick{
    CHZWebXiYiViewController *webXiYi = [[CHZWebXiYiViewController alloc] init];
    [self.navigationController pushViewController:webXiYi animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
