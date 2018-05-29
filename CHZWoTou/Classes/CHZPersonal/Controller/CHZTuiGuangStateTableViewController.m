//
//  CHZTuiGuangStateTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZTuiGuangStateTableViewController.h"
#import "CHZTuiGuangStateTableViewCell.h"
#import "CHZTuiGuangStateTableViewCell.h"
#import "CHZTuiGuangModel.h"
#import "CHZTuiGSecTableViewCell.h"
#import "CHZTuiInfoTableViewCell.h"
#import "CHZTGInfoModel.h"

@interface CHZTuiGuangStateTableViewController ()
@property (nonatomic, strong)NSArray *namesArr;
@property (nonatomic, strong)NSMutableArray *sourceDatas;

/**
 *
 */
@property (nonatomic, weak)CHZTuiGuangStateTableViewCell *firstCell;
@property (nonatomic, weak)CHZTuiGSecTableViewCell *secCell;
@property (nonatomic, weak)CHZTuiGSecTableViewCell *thirdCell;



@property (nonatomic,strong)AFHTTPSessionManager *mgr;
@property (nonatomic,strong)CHZTuiGuangModel *tuigM;

@end

@implementation CHZTuiGuangStateTableViewController

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}

- (void)getTuiGInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    
    [self.mgr POST:API_TUIGSTATE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (200 == [responseObject[@"code"] integerValue]) {
            CHZTuiGuangModel *tuigM = [[CHZTuiGuangModel alloc] initWithDict:responseObject];
            if (tuigM.infoArr) {
                self.sourceDatas = [tuigM.infoArr mutableCopy];
                CHZTGInfoModel *temp =[[CHZTGInfoModel alloc] init];
                [self.sourceDatas insertObject:temp atIndex:0];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationTop];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.firstCell.tuiGuangNum.text = tuigM.count;
                self.secCell.tuiGuangNum.text = tuigM.last_month_count;
                self.thirdCell.tuiGuangNum.text = tuigM.month_count;
            });
            
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSArray *)sourceDatas{
    if (!_sourceDatas) {
        _sourceDatas = [NSMutableArray array];
    }
    return _sourceDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用帮助";
    self.view.backgroundColor = CHZGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 0.f;
    self.tableView.sectionFooterHeight = 22.f;
    self.tableView.contentInset = UIEdgeInsetsMake(22-35, 0, 0, 0);
    
    _namesArr = @[@"总推广",@"上月推广",@"本月推广",@"推广详情"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZTuiGuangStateTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"firstCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZTuiGSecTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"secCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZTuiGSecTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"thirdCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZTuiInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"infoTGCell"];
    
    
    [self getTuiGInfo];
    
    
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

    if (section == 3) {
        return self.sourceDatas.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CHZTuiGuangStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
        self.firstCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        CHZTuiGSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secCell" forIndexPath:indexPath];
        cell.nameLB.text = _namesArr[indexPath.section];
        self.secCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 2){
        CHZTuiGSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdCell" forIndexPath:indexPath];
        cell.nameLB.text = _namesArr[indexPath.section];
        self.thirdCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            CHZTuiGSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdCell" forIndexPath:indexPath];
            cell.tuiGuangNum.hidden = YES;
            cell.nameLB.text = _namesArr[indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            CHZTuiInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoTGCell" forIndexPath:indexPath];
            CHZTGInfoModel *infoM = self.sourceDatas[indexPath.row];
            cell.infoModel = infoM;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        

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
