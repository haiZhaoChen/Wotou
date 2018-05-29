//
//  CHZSharedCollectionViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/15.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZSharedCollectionViewCell.h"
#import "CHZSharedItemData.h"
#import "CHZArticleTableViewCell.h"
#import "CHZArticleData.h"
#import "CHZTitleName.h"
#import "CHZSaveSharedData.h"
#import "CHZNoticeModel.h"
#import "CHZArticleDetailViewController.h"




@interface CHZSharedCollectionViewCell()<UITableViewDelegate,UITableViewDataSource>{
    CHZSharedItemData* _menuItem;
}
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong)NSDictionary *params;

@property (nonatomic, strong)AFHTTPSessionManager *mgr;
@property (nonatomic, strong)NSMutableArray<CHZArticleData *> *dataSources;

@property (nonatomic, weak)CHZTitleName *titleName;

@property (nonatomic, weak)UIImageView *topImgView;
@property (nonatomic, strong)CHZNoticeModel *notice;

@end

@implementation CHZSharedCollectionViewCell

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}

+ (instancetype)returnCollectionViewCell:(UICollectionView* )curCollectionView
                              identifier:(NSString* )identifierString
                               indexPath:(NSIndexPath* )indexPath
                               listModel:(CHZSharedItemData* )model{
    CHZSharedCollectionViewCell *cell = [curCollectionView dequeueReusableCellWithReuseIdentifier:identifierString forIndexPath:indexPath];
    
    cell ->_menuItem = model;
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.tableView  = [[UITableView alloc] initWithFrame:self.contentView.bounds];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
//        self.tableView.rowHeight =  UITableViewAutomaticDimension;
//        self.tableView.estimatedRowHeight = 150;

//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZArticleTableViewCell class]) bundle:nil] forCellReuseIdentifier:CHZSharedArticleCell];
        
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf commonRefresh];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshCurCell];
        }];
        
//        [self beginRefreshCurCell];

        
        
    }
    
    return self;
}

- (void)commonRefresh{
    
    [self.mgr.operationQueue cancelAllOperations];
    HZLog(@"请求数据接口");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    NSString *nameId = self.titleName.nameId;
    
    params[@"cid"] = nameId;
    params[@"page"] = @"";
    params[@"type"] = @0;
    if (self.dataSources.count >0) {
        CHZArticleData *artFirst =  self.dataSources[0];
        params[@"aid"] = artFirst.articleId;
     
    }
    
    self.params = params;
    
    [self.mgr POST:API_MASTER parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if (self.params != params) return ;
        
        HZLog(@"调用管理接口成功");
        if (202 == [responseObject[@"code"] integerValue]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSMutableArray *dataSources = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"data"]) {
                    CHZArticleData *artData = [[CHZArticleData alloc] initWithDict:dict];
                    [dataSources addObject:artData];
                }
                
                if (self.dataSources.count >0) {
                    //把最新数组追加到旧数据前面
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObjectsFromArray:dataSources];
                    [tempArray addObjectsFromArray:self.dataSources];
                    self.dataSources = tempArray;

                }else{
                    self.dataSources = dataSources;
                }
                
                CHZSaveSharedData *articleList = [CHZSaveSharedData saveSharedDataWith:dataSources.mutableCopy nameId:nameId];
                NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:articleList,articleList.nameId, nil];
                if ([self.delegate respondsToSelector:@selector(artcleListDataWithCell:dictData:)]) {
                    [self.delegate artcleListDataWithCell:self dictData:dictTemp];
                }
                
                if ([self.delegate respondsToSelector:@selector(updateNum:)]) {
                    [self.delegate updateNum:dataSources.count];
                }
                
                
                [self.tableView reloadData];
            }

        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期TokenPass
            if ([self.delegate respondsToSelector:@selector(TokenPass)]) {
                [self.delegate TokenPass];
            }
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            if ([self.delegate respondsToSelector:@selector(noMoneyGoBack)]) {
                [self.delegate noMoneyGoBack];
            }
        }else if (400 == [responseObject[@"code"] integerValue]){
            if ([self.delegate respondsToSelector:@selector(updateNum:)]) {
                [self.delegate updateNum:0];
            }
        }else{
            
        }
        
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"调用管理接口成功%@",error);
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

- (void)endRefreshCurCell{
    self.tableView.mj_header.state = MJRefreshStateIdle;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
}


- (void)refreshCurCell{
    
    [self.mgr.operationQueue cancelAllOperations];
    HZLog(@"请求数据接口");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    NSString *nameId = self.titleName.nameId;
    
    params[@"cid"] = nameId;
    params[@"page"] = @"";
    params[@"type"] = @1;
    if (self.dataSources.count >0) {
        CHZArticleData *artFirst =  [self.dataSources lastObject];
        params[@"aid"] = artFirst.articleId;
        
    }
    
    [self.mgr POST:API_MASTER parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        if (self.params != params) return ;
        
        HZLog(@"调用管理接口成功");
        if (201 == [responseObject[@"code"] integerValue]) {
            
            if (responseObject[@"data"] != [NSNull null]) {

                NSArray *tempArr = responseObject[@"data"];
                if (!tempArr.count) {
                    [self.tableView.mj_footer endRefreshing];
                    if ([self.delegate respondsToSelector:@selector(updateNum:)]) {
                        [self.delegate updateNum:0];
                    }
                    
                    return;
                }
                
                
                NSMutableArray *dataSources = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"data"]) {
                    CHZArticleData *artData = [[CHZArticleData alloc] initWithDict:dict];
                    [dataSources addObject:artData];
                }
                
                if (self.dataSources.count >0) {
                    //把最新数组追加到旧数据前面
                    UIImage *image = [UIImage imageNamed:@"Avast"];
                    for (int i= 0; i>100; i++) {
                        [[SDImageCache sharedImageCache] storeImage:image forKey:@"anUrlString" toDisk:YES];
                    }
                    [self.dataSources addObjectsFromArray:dataSources];
                    
                }else{
                    self.dataSources = dataSources;
                }
                
                CHZSaveSharedData *articleList = [CHZSaveSharedData saveSharedDataWith:dataSources.mutableCopy nameId:nameId];
                NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:articleList,articleList.nameId, nil];
                if ([self.delegate respondsToSelector:@selector(artcleListDataWithCell:dictData:)]) {
                    [self.delegate artcleListDataWithCell:self dictData:dictTemp];
                }
                
                if ([self.delegate respondsToSelector:@selector(updateNum:)]) {
                    [self.delegate updateNum:dataSources.count];
                }
                
                
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
            
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期TokenPass
            if ([self.delegate respondsToSelector:@selector(TokenPass)]) {
                [self.delegate TokenPass];
            }
            
        }else if(705 == [responseObject[@"code"] integerValue]){
            if ([self.delegate respondsToSelector:@selector(noMoneyGoBack)]) {
                [self.delegate noMoneyGoBack];
            }
        }else if (402 == [responseObject[@"code"] integerValue]){
            
            [self.tableView.mj_footer endRefreshing];
            if ([self.delegate respondsToSelector:@selector(updateNum:)]) {
                [self.delegate updateNum:0];
            }
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"调用管理接口成功%@",error);
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

- (void)getTopADImg{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    [self.mgr POST:API_NOTICE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"公告");
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                CHZNoticeModel *notice = [[CHZNoticeModel alloc] initWithDict:responseObject[@"data"]];
                self.notice = notice;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView *viewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.width*0.4)];
                    
                    viewTemp.userInteractionEnabled = YES;//打开用户交互
                    //初始化一个手势
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
                    //为图片添加手势
                    [viewTemp addGestureRecognizer:singleTap];
                    self.topImgView = viewTemp;
                    self.tableView.tableHeaderView = self.topImgView;
                    [self.topImgView sd_setImageWithURL:[NSURL URLWithString:notice.thumbnail]];
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//点击事件
-(void)singleTapAction:(UIGestureRecognizer *)ges{
    //具体的实现
    if (self.notice) {
        
        if ([self.delegate respondsToSelector:@selector(clickToNotice:)]) {
            [self.delegate clickToNotice:self.notice.nId];
        }
    }
}


//配置
- (void)configurationPostBackDictionary:(CHZTitleName *)titleName dictData:(NSDictionary<NSString *,CHZSaveSharedData *> *)dict{
    self.titleName = titleName;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    
    if (self.dataSources.count > 0){
        
        [self.dataSources removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    
    if ([titleName.nameId isEqualToString:@"4"]) {
        //判断有无公告
        [self getTopADImg];
        
        
    }else{
        
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    }
    
    CHZSaveSharedData *sharedData = dict[titleName.nameId];
    
    if (sharedData.articleDatas && sharedData.articleDatas.count >0) {
        self.dataSources = sharedData.articleDatas.count > 0 ? sharedData.articleDatas.mutableCopy : nil;
        
        [self.tableView reloadData];
        
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
   
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSources.count) {
        return self.dataSources.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CHZArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHZSharedArticleCell];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CHZRGBColor(230, 230, 230);
    
    CHZArticleData *artData = self.dataSources[indexPath.row];
    
    cell.artData = artData;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//开始刷新
- (void)beginRefreshCurCell{
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CHZArticleData *aData = self.dataSources[indexPath.row];
    CHZArticleDetailViewController *detailVC = [[CHZArticleDetailViewController alloc] initWithArticleID:aData];
    
    if ([self.delegate respondsToSelector:@selector(artclePushDetailView:andTableVCell:andPushVC:)]) {
        [self.delegate artclePushDetailView:self andTableVCell:[self.tableView cellForRowAtIndexPath:indexPath] andPushVC:detailVC];
    }
}



@end
