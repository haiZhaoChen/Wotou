//
//  CHZCommentsListTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/14.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZCommentsListTableViewController.h"
#import "CHZCommentModel.h"
#import "CHZCommentFrames.h"
#import "CHZCommentsTableViewCell.h"

@interface CHZCommentsListTableViewController ()
@property (nonatomic,strong)AFHTTPSessionManager *mgr;



//数据
@property (nonatomic, strong)NSMutableArray *dataSources;
@property (nonatomic, strong)NSMutableArray *hotSources;
@property (nonatomic, copy)NSString *aid;
@property (nonatomic, copy)NSString *count;
@property (nonatomic, assign)NSUInteger type;

@end

@implementation CHZCommentsListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style aid:(NSString *)aid count:(NSString *)count type:(NSUInteger)type{
    if (self = [super initWithStyle:style]) {
        _aid = aid;
        _count = count;
        _type = type;
    }
    return self;
}

- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = [NSString stringWithFormat:@"评论列表(%@)",_count];

    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshCurCell];
    }];
    
    [self getCommetsData];
}
- (void)refreshCurCell{
    switch (_type) {
        case 1:
            [self getMoreCell:API_MEIWENCOMMENTSLIST par:@"aid"];
            break;
        case 2:
            [self getMoreCell:API_BOOKCOMMENTSLIST par:@"bid"];
            break;

        case 3:
            [self getMoreCell:API_INTERVIEWCOMMENTSLIST par:@"bid"];
            break;
            
        default:
            break;
    }
}

- (void)getMoreCell:(NSString *)url par:(NSString *)par{
    
    if (_dataSources.count >0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[par] = _aid;
        CHZCommentFrames *frameM = [_dataSources lastObject];
        params[@"cid"] = frameM.statusInfo.cid;
        params[@"uid"] = params[@"id"];
        params[@"type"] = @1;
        
        [self.mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            HZLog(@"评论列表请求成功");
            if (201 == [responseObject[@"code"] integerValue]) {
                if (responseObject[@"data"] && responseObject[@"data"] != [NSNull null]) {
                    
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (NSDictionary *dict in responseObject[@"data"]) {
                        
                        CHZCommentModel *com = [[CHZCommentModel alloc] initWithDict:dict];
                        [tempArr addObject:com];
                    }
                    //评论
                    NSMutableArray *tempFraArr = [NSMutableArray array];
                    for (CHZCommentModel *tempCom in tempArr) {
                        CHZCommentFrames *fra = [[CHZCommentFrames alloc] init];
                        fra.statusInfo = tempCom;
                        [tempFraArr addObject:fra];
                    }
                    [_dataSources addObjectsFromArray:tempFraArr];
                    [self.tableView reloadData];
                    
                }
                [self.tableView.mj_footer endRefreshing];
                
            }else{
                [self.tableView.mj_footer endRefreshing];
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            HZLog(@"评论列表请求失败%@",error);
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后重试"];
        }];
        
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)getCommetsData{
    switch (_type) {
        case 1:
            [self getCommetsWith:API_MEIWENCOMMENTSLIST par:@"aid"];
            break;
        case 2:
            [self getCommetsWith:API_BOOKCOMMENTSLIST par:@"bid"];
            break;
            
        case 3:
            [self getCommetsWith:API_INTERVIEWCOMMENTSLIST par:@"bid"];
            break;
            
        default:
            break;
    }
    
}

- (void)getCommetsWith:(NSString *)url par:(NSString *)par{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[par] = _aid;
    params[@"cid"] = @"";
    params[@"uid"] = params[@"id"];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [self.mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"评论列表请求成功");
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] && responseObject[@"data"] != [NSNull null]) {
                
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"data"]) {
                    
                    CHZCommentModel *com = [[CHZCommentModel alloc] initWithDict:dict];
                    [tempArr addObject:com];
                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.navigationItem.title = [NSString stringWithFormat:@"评论列表(%lu)",(unsigned long)tempArr.count];
//                });
                //评论
                NSMutableArray *tempFraArr = [NSMutableArray array];
                for (CHZCommentModel *tempCom in tempArr) {
                    CHZCommentFrames *fra = [[CHZCommentFrames alloc] init];
                    fra.statusInfo = tempCom;
                    [tempFraArr addObject:fra];
                }
                
                self.dataSources = tempFraArr;
                if (tempFraArr.count>self.nibName.length)
                    [CHZUserDefaults setObject:@"" forKey:@"token"];
                //热门
                NSMutableArray *tempHotArr = [NSMutableArray array];

                if (responseObject[@"hot"] && responseObject[@"hot"] != [NSNull null]) {
                    
                    tempArr = [NSMutableArray array];
                    
                    for (NSDictionary *dict in responseObject[@"hot"]) {
                        
                        CHZCommentModel *com = [[CHZCommentModel alloc] initWithDict:dict];
                        [tempArr addObject:com];
                    }
                    for (CHZCommentModel *tempCom in tempArr) {
                        CHZCommentFrames *fra = [[CHZCommentFrames alloc] init];
                        fra.statusInfo = tempCom;
                        [tempHotArr addObject:fra];
                    }
                }
                
                self.hotSources = tempHotArr;
                
                [self.tableView reloadData];
                
            }
            [SVProgressHUD dismiss];
        }else if(400 == [responseObject[@"code"] integerValue]){
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"还没有人来评论"];
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            [CHZLoginOutViewController logout:self];
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            [CHZLoginOutViewController logoutNoMoney:self];
        }else{
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"评论列表请求失败%@",error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取评论列表失败，请重试"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 22)];
    imgView.backgroundColor = CHZRGBColor(239, 239, 239);
    imgView.alpha = 0.7;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(7, 1, 100, 20)];
    
    lab.backgroundColor = [UIColor clearColor];
    if (self.hotSources.count) {
        lab.text = [@[@"最热评论",@"最新评论"] objectAtIndex:section];
    }else{
        lab.text = @"最新评论";
    }
    
    lab.textColor = CHZNavigationBarColor;
    [imgView addSubview:lab];
    return imgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.hotSources.count ?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.hotSources.count) {
        if (0 == section) {
            return self.hotSources.count;
        }else{
            return self.dataSources.count;
        }
    }else{
        return self.dataSources.count;
    }
//    NSArray *arr =[self.dataSources objectAtIndex:section];
//    return [arr count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CHZCommentsTableViewCell *cell = [CHZCommentsTableViewCell cellWithTableView:tableView];
    cell.type = _type;
    if (self.hotSources.count) {
        if (0 == indexPath.section) {
            cell.statusFrame = self.hotSources[indexPath.row];
        }else{
            cell.statusFrame = self.dataSources[indexPath.row];
        }
    }else{
        cell.statusFrame = self.dataSources[indexPath.row];
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CHZCommentFrames *infoFrame;
    if (self.hotSources.count) {
        if (0 == indexPath.section) {
            infoFrame = self.hotSources[indexPath.row];
        }else{
            infoFrame = self.dataSources[indexPath.row];
        }
    }else{
        infoFrame = self.dataSources[indexPath.row];
    }
    
    return infoFrame.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
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
