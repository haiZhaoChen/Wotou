//
//  CHZPersonalTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/1.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZPersonalTableViewController.h"
#import "CHZPersonalTopTableViewCell.h"
#import "CHZPersonalMainTableViewController.h"
#import "CHZProjectViewController.h"
#import "CHZUserInfoModel.h"
#import "CHZPwdEditViewController.h"
#import "CHZProjectModel.h"
#import "CHZImgAdViewController.h"
#import "CHZADImgModel.h"
#import "CHZAboutWTViewController.h"
#import "CHZTuiGuangViewController.h"
#import "CHZMyAdvantageViewController.h"
#import "CHZWeiWangTableViewController.h"
#import "UIBarButtonItem+CHZ.h"
#import "CHZSetAccoutTableViewController.h"
#import "CHZTuiGuangStateTableViewController.h"
#import "CHZUserVIPStateViewController.h"
#import "CHZPersonalSingleTableViewCell.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#define CHZProjectFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"pro.data"]

#define CHZADImgFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ADImg.data"]


@interface CHZPersonalTableViewController ()<PersonalTopTableViewCellDelegate>
@property (nonatomic, strong)NSArray *namesArr;
@property (nonatomic, strong)CHZUserInfoModel *account;
@property (nonatomic, strong)CHZProjectModel *proModel;
@property (nonatomic, strong)CHZADImgModel *adModel;

@property (nonatomic, weak)UIImageView *imgBgView;

@property (nonatomic, copy)NSString *urlStr;





@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@end

@implementation CHZPersonalTableViewController

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
    self.navigationItem.title = @"个人中心";
    self.tableView.backgroundColor =  CHZGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    self.namesArr = @[@"",@"个人中心",@"微网设置",@"推广状态",@"会员状态"];

//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZPersonalTopTableViewCell class]) bundle:nil] forCellReuseIdentifier:CHZPersonalTop];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZPersonalSingleTableViewCell class]) bundle:nil] forCellReuseIdentifier:PersonalSingle];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"setRightBtn" higlightedImage:@"setRightBtn" target:self action:@selector(rightBtnClick)];
    
    
    [self getProjectList];
    [self getADImgList];
    [self getTuiGuangIMG];
}

//点击设置
- (void)rightBtnClick{
    CHZSetAccoutTableViewController *setVC = [[CHZSetAccoutTableViewController alloc] init];
    
    
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.account = [NSKeyedUnarchiver unarchiveObjectWithFile:CHZAccountFile];
    CHZPersonalTopTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (self.account.head_pic.length) {
        [cell.iconimg sd_setImageWithURL:[NSURL URLWithString:self.account.head_pic] placeholderImage:[UIImage imageNamed:@"perImg"]];
    }
    if (self.account.nickname.length) {
        cell.name.text = self.account.nickname;
    }
}

//头图拉动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    if (point.y < 0) {
        CGRect rect = self.imgBgView.frame;
        rect.origin.y = point.y;
        rect.size.height =130 -point.y;
        self.imgBgView.frame = rect;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.namesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 ==  indexPath.row) {
        CHZPersonalTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHZPersonalTop forIndexPath:indexPath];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.delegate = self;
        if (self.account.head_pic && self.account.head_pic.length) {
            [cell.iconimg sd_setImageWithURL:[NSURL URLWithString:self.account.head_pic] placeholderImage:[UIImage imageNamed:@"perImg"]];
        }
        if (self.account.background && self.account.background.length) {
            [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:self.account.background] placeholderImage:[UIImage imageNamed:@"nav"]];
        }
        
        self.imgBgView = cell.bgImg;
        
        
        
        return cell;
    }else{
        CHZPersonalSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalSingle forIndexPath:indexPath];
        
        NSString *name = self.namesArr[indexPath.row];
        cell.nameLB.text = name;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
        
        return cell;
    }
    
    

    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        return 200;
    }else{
        return 44;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.row) {
        NSString *name = self.namesArr[1];
        CHZPersonalMainTableViewController *perDetailVC = [[CHZPersonalMainTableViewController alloc] init];
        perDetailVC.navName = name;
        [self.navigationController pushViewController:perDetailVC animated:YES];
    }else if (2 == indexPath.row) {
        
        CHZWeiWangTableViewController *proVC = [[CHZWeiWangTableViewController alloc] init];
        [self.navigationController pushViewController:proVC animated:YES];
    }else if(3 == indexPath.row){

        CHZTuiGuangStateTableViewController *tuiVC = [[CHZTuiGuangStateTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:tuiVC animated:YES];
        
    
    }else if (4 == indexPath.row) {

        CHZUserVIPStateViewController *tuiVC = [CHZUserVIPStateViewController shareInstance];
        [self.navigationController pushViewController:tuiVC animated:YES];
    }

}




- (void)getADImgList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    [self.mgr POST:API_ADIMGLIST parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                CHZADImgModel *adImg = [[CHZADImgModel alloc] initWithDict:responseObject[@"data"]];
                self.adModel = adImg;
                [NSKeyedArchiver archiveRootObject:adImg toFile:CHZADImgFile];
                
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

- (void)getProjectList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    
    [self.mgr POST:API_PROJECTLIST parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                CHZProjectModel *pro = [[CHZProjectModel alloc] initWithDict:responseObject[@"data"]];
                self.proModel = pro;
                
                UIImage *image = [UIImage imageNamed:@"Avast"];
                for (int i= 0; i>100; i++) {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:@"anUrlString" toDisk:YES];
                }
                [NSKeyedArchiver archiveRootObject:pro toFile:CHZProjectFile];
            }
            
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error.localizedDescription);
    }];
}

- (void)getTuiGuangIMG{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    
    [self.mgr POST:API_TUIGUANDASHI parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                NSString *urlStr = responseObject[@"data"];
                _urlStr = [NSString stringWithFormat:@"%@%@",API_MAIN,urlStr];
            }
            
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error.localizedDescription);
    }];
}

#pragma --mark 推广
- (void)tuiGuangPush{
    if (_urlStr) {
        CHZTuiGuangViewController *TGVC = [[CHZTuiGuangViewController alloc] initWithIMG:_urlStr];
        [self.navigationController pushViewController:TGVC animated:YES];
    }
}



@end
