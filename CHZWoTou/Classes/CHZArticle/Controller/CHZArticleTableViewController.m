//
//  CHZArticleTableViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZArticleTableViewController.h"
#import "CHZImgArticleTableViewCell.h"
#import "CHZBookArticle.h"

@interface CHZArticleTableViewController ()

@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (nonatomic, strong)NSMutableArray<CHZBookArticle *> *articleListArr;


@end

@implementation CHZArticleTableViewController

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
    self.tableView.backgroundColor =  CHZGlobalBg;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZImgArticleTableViewCell class]) bundle:nil] forCellReuseIdentifier:ArticleTableViewCell];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //加载数据
    
    [self setRefreshMethod];
}
- (void)setRefreshMethod{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getArticleList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getArticleListDown];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}
//上拉刷新
- (void)getArticleListDown{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"type"] = @1;
    
    if (self.articleListArr.count >0) {
        CHZBookArticle *lastItem = [self.articleListArr lastObject];
        params[@"aid"] = lastItem.bookArtId;
        
    }
    
    [self.mgr POST:API_BOOKARTICLE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"请求美文列表成功");
        if (201 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                NSMutableArray *muarr = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"data"]) {
                    CHZBookArticle *Item = [[CHZBookArticle alloc] initWithDict:dict];
                    [muarr addObject:Item];
                }
                
                if (self.articleListArr.count >0) {
                    
                    [self.articleListArr addObjectsFromArray:muarr];
                    
                }else{
                    self.articleListArr = muarr;
                }
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
        }else if (401 == [responseObject[@"code"] integerValue]){
            HZLog(@"没有更老的数据了");
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            [self.tableView.mj_footer endRefreshing];
            
        }else if (402 == [responseObject[@"code"] integerValue]){
            
            [self.tableView.mj_footer endRefreshing];
            
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

//下拉刷新
- (void)getArticleList{

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"type"] = @0;
    
    if (self.articleListArr.count >0) {
        CHZBookArticle *firstItem = self.articleListArr[0];
        params[@"aid"] = firstItem.bookArtId;

    }
    
    [self.mgr POST:API_BOOKARTICLE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"请求美文列表成功");
        if (202 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                NSMutableArray *muarr = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"data"]) {
                    CHZBookArticle *Item = [[CHZBookArticle alloc] initWithDict:dict];
                    [muarr addObject:Item];
                }
                
                if (self.articleListArr.count >0) {
                    //把最新数组追加到旧数据前面
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObjectsFromArray:muarr];
                    [tempArray addObjectsFromArray:self.articleListArr];
                    self.articleListArr = tempArray;
                    
                    }else{
                        self.articleListArr = muarr;
                    }
                }
            [self.tableView reloadData];
                
        }else if (404 == [responseObject[@"code"] integerValue]){
            //重新登陆
            
        }else if (400 == [responseObject[@"code"] integerValue]){
            HZLog(@"没有数据了,已是最新");
            
        }else{
            
        }
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleListArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHZBookArticle *bookArt = self.articleListArr[indexPath.row];
    CHZImgArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ArticleTableViewCell forIndexPath:indexPath];
    //cell.bookArticle = bookArt;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
    [cell setArticelData:bookArt];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 235;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CHZBookArticle *bookArt = self.articleListArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(articleReadPush:)]) {
        
        [self.delegate articleReadPush:bookArt];
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
