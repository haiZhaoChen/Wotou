//
//  CHZRegistTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZRegistTableViewController.h"
#import "CHZReDelegateTableViewCell.h"
#import "CHZApplyForTableViewCell.h"
#import "Util.h"
#import "CHZADListShow.h"
#import "CHZMapModel.h"
#import "CHZMapSelectTableViewCell.h"
#import "ZmjPickView.h"
#import "CHZPayViewController.h"
#import "CHZPickView.h"
#import "CHZWebXiYiViewController.h"
#import "CHZRegistModel.h"

#define LASTONE 5

@interface CHZRegistTableViewController ()<ApplyForTableViewCellDelegate,UITextFieldDelegate,MapSelectTableViewCellDelegate>

@property (nonatomic, strong)NSArray *namesArr;

@property (nonatomic,strong)AFHTTPSessionManager *mgr;
//判断是否有选项不符合规定
@property (nonatomic, assign)BOOL isWrong;
//判断省份是否加入
@property (nonatomic, assign)BOOL isMapNone;


@property (nonatomic,copy)NSString *mapAddress;

@property (nonatomic, strong)NSArray *agentArr;

@property (nonatomic, strong)CHZRegistModel *regM;

@end

@implementation CHZRegistTableViewController


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
    self.navigationItem.title = @"注册";
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.namesArr = @[@"用户名称",@"手机号码",@"微信号码",@"密     码",@"重复密码",@""];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelRe)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:CHZRGBColor(253, 253, 233),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    
    [self setHeaderView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZReDelegateTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReDelegateCell];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZMapSelectTableViewCell class]) bundle:nil] forCellReuseIdentifier:MapSelectCell];
    
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // 3.监听键盘的通知
    [CHZNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [CHZNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self getAgentArr:NO];
    
}

#pragma --mark选择map的代理
- (void)selectMap{
    if (_agentArr) {
        CHZPickView *selectMap = [[CHZPickView alloc] initWithAgentArr:_agentArr];
        [selectMap show];
        __weak typeof(self) weakSelf = self;
        
        selectMap.btnActionBlock = ^(NSInteger xianId, NSString *xianName){
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            CHZMapSelectTableViewCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            if (xianName.length >0) {
                strongSelf.isMapNone = YES;
                cell.mapName.text = xianName;
                self.mapAddress = [NSString stringWithFormat:@"%lu",(long)xianId];
                cell.mapName.textColor = [UIColor blackColor];
            }
            
            
        };
    }else{
        [self getAgentArr:YES];
    }
    
}
//获取代理商列表
- (void)getAgentArr:(BOOL)agen{
    
    if (agen) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
    }
    
    [self.mgr POST:API_AGENTLIST parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            _agentArr = (NSArray *)responseObject;
            if (agen) {
                [SVProgressHUD dismiss];
                CHZPickView *selectMap = [[CHZPickView alloc] initWithAgentArr:self.agentArr];
                [selectMap show];
                __weak typeof(self) weakSelf = self;
                
                selectMap.btnActionBlock = ^(NSInteger xianId, NSString *xianName){
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    strongSelf.isMapNone = YES;
                    CHZMapSelectTableViewCell *cell = [strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                    cell.mapName.text = xianName;
                    self.mapAddress = [NSString stringWithFormat:@"%lu",(long)xianId];
                    cell.mapName.textColor = [UIColor blackColor];
                };

            }
        }
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
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
        CHZMapSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MapSelectCell forIndexPath:indexPath];
        cell.titleName.text = @"选代理商";
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
        cell.conTF.placeholder = @"请输入微信号";
    }
    
    if (3 == indexPath.row) {
        cell.conTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.conTF.secureTextEntry = YES;
        cell.conTF.placeholder = @"大于六位数的密码";
        
    }
    if (4 == indexPath.row) {
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
        [self.mgr POST:API_CHECKNAMEONLY parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
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
    
//    [self EditAlertShow];
//    
//    return;
    
    if (self.isWrong) {
        [SVProgressHUD showErrorWithStatus:@"请修改不符合要求的选项"];
        return;
    }
    CHZReDelegateTableViewCell *cell;
    NSMutableArray *values = [NSMutableArray array];
    
    
    
    for (int i = 0; i< LASTONE; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:path];
        
        if (!cell.conTF.text.length) {
            NSString *str = [NSString stringWithFormat:@"%@ 不能为空!",cell.titleStr];
            [SVProgressHUD showErrorWithStatus:str];
            return;
        }
        [values addObject:cell.conTF.text];
    }
    NSString *tempKey = values[3];
    if (tempKey.length <6) {
        [SVProgressHUD showErrorWithStatus:@"请输入大于六位数的密码"];
        return;
    }
    
    if (![values[3] isEqualToString:values[4]]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    if (!self.isMapNone) {
        [SVProgressHUD showErrorWithStatus:@"填写代理商"];
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
    
    params[@"name"] = values[0];
    params[@"tel"] = values[1];
    params[@"wechat"] = values[2];
    params[@"password"] = values[3];
    params[@"pid"] = self.mapAddress;
    
    [self.mgr POST:API_APPLYFORREGIST parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (200 == [responseObject[@"code"] integerValue]) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];

            [CHZUserDefaults setObject:params[@"name"] forKey:@"registUserName"];
            _regM = [[CHZRegistModel alloc] initWithDict:responseObject[@"data"]];
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self EditAlertShow];
            });
        }else if(400 == [responseObject[@"code"] integerValue]){
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }else{
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"申请失败，请稍后再试"];
        HZLog(@"%@",error);
    }];
    
}

- (void)EditAlertShow{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"点击直接进入支付页面\n否则无法正常登陆" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * PH = [UIAlertAction actionWithTitle:@"进入支付页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CHZPayViewController *payVC = [[CHZPayViewController alloc] initWith:_regM];
        [self.navigationController pushViewController:payVC animated:YES];
        
    }];

    [alert addAction:PH];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
