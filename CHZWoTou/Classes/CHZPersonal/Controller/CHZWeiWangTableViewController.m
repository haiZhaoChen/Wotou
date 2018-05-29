//
//  CHZWeiWangTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZWeiWangTableViewController.h"
#import "CHZProjectViewController.h"
#import "CHZProjectModel.h"
#import "CHZADImgModel.h"
#import "CHZImgAdViewController.h"
#import "CHZMyAdvantageViewController.h"

#define CHZProjectFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"pro.data"]

#define CHZADImgFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ADImg.data"]


@interface CHZWeiWangTableViewController ()
@property (nonatomic, strong)NSArray *namesArr;

@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (nonatomic, strong)CHZProjectModel *proModel;
@property (nonatomic, strong)CHZADImgModel *adModel;



@end

@implementation CHZWeiWangTableViewController

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
    
    self.view.backgroundColor = CHZGlobalBg;
    self.navigationItem.title = @"微网设置";

    self.tableView.rowHeight = 44.f;
    
    self.namesArr = @[@[@"我的优势"],@[@"经营项目",@"轮播管理"]];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"personCell"];
    self.tableView.rowHeight = 44.f;
    
    self.proModel = [NSKeyedUnarchiver unarchiveObjectWithFile:CHZProjectFile];
    if (!self.proModel) {
        [self getProjectList];
    }
    
    self.adModel = [NSKeyedUnarchiver unarchiveObjectWithFile:CHZADImgFile];
    if (self.adModel) {
        [self getADImgList];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.namesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.namesArr[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
    NSString *str = self.namesArr[indexPath.section][indexPath.row];
    
    cell.textLabel.text = str;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    if (indexPath.section == 1 && indexPath.row == 1) {
        UILabel *label=[[UILabel alloc]init];
        label.text=@"修改轮播";
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor grayColor];
        [label sizeToFit];
        label.frame=CGRectMake(kScreenWidth - label.frame.size.width-15, (44 - label.frame.size.height) *0.5, label.frame.size.width, label.frame.size.height);
        [cell.contentView addSubview:label];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    

    
    cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.f;
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




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CHZProjectViewController *proVC = [[CHZProjectViewController alloc] init];
            proVC.navName = @"经营项目";
            [self.navigationController pushViewController:proVC animated:YES];
            if (self.proModel) {
                proVC.proModel = self.proModel;
            }
            [proVC returnText:^(BOOL isNeedGet) {
                if (isNeedGet) {
                    [self getProjectList];
                }
            }];

        }else{
            
            CHZImgAdViewController *adVC = [[CHZImgAdViewController alloc] init];
            if (self.adModel) {
                adVC.adModel = self.adModel;
            }
            
            [adVC returnText:^(BOOL isNeedGet) {
                if (isNeedGet) {
                    [self getADImgList];
                }
            }];
            [self.navigationController pushViewController:adVC animated:YES];
            
        }
    }else{
        CHZMyAdvantageViewController *myAdvantage = [[CHZMyAdvantageViewController alloc] init];
        [self.navigationController pushViewController:myAdvantage animated:YES];
    }
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
