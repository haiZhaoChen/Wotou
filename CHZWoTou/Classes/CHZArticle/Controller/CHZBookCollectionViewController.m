//
//  CHZBookCollectionViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookCollectionViewController.h"
#import "CHZCollectionViewCell.h"
#import "CHZBookVideo.h"

@interface CHZBookCollectionViewController ()<CHZCollectionViewCellDelegate>

@property (nonatomic, strong) CHZCollectionViewCell *cell;

@property (nonatomic, strong) NSMutableArray *bookListArr;
@property (nonatomic,strong)AFHTTPSessionManager *mgr;
@end

@implementation CHZBookCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


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
    self.collectionView.backgroundColor =  CHZGlobalBg;

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[CHZCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CHZCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    [self setRefreshMethod];
    
}


- (void)setRefreshMethod{
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getArticleList];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getArticleListDown];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
}


//上拉刷新
- (void)getArticleListDown{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"type"] = @1;
    
    if (self.bookListArr.count >0) {
        CHZBookVideo *lastItem = [self.bookListArr lastObject];
        params[@"aid"] = lastItem.bookId;
        
    }
    
    [self.mgr POST:API_BOOKVIDEO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"请求美文列表成功");
        if (201 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                NSMutableArray *muarr = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"data"]) {
                    CHZBookVideo *Item = [[CHZBookVideo alloc] initWithDict:dict];
                    [muarr addObject:Item];
                }
                
                if (self.bookListArr.count >0) {
                    
                    [self.bookListArr addObjectsFromArray:muarr];
                    
                }else{
                    self.bookListArr = muarr;
                }
            }
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
            
        }else if (401 == [responseObject[@"code"] integerValue]){
            HZLog(@"没有更老的数据了");
            
            [self.collectionView.mj_footer endRefreshing];
            
        }else if (402 == [responseObject[@"code"] integerValue]){
            
            [self.collectionView.mj_footer endRefreshing];
            
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

//下拉刷新
- (void)getArticleList{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"type"] = @0;
    
    if (self.bookListArr.count >0) {
        CHZBookVideo *firstItem = self.bookListArr[0];
        params[@"aid"] = firstItem.bookId;
        
    }
    
    [self.mgr POST:API_BOOKVIDEO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"请求美文列表成功");
        if (202 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != [NSNull null]) {
                NSMutableArray *muarr = [NSMutableArray array];
                for (NSDictionary *dict in responseObject[@"data"]) {
                    CHZBookVideo *Item = [[CHZBookVideo alloc] initWithDict:dict];
                    [muarr addObject:Item];
                }
                
                if (self.bookListArr.count >0) {
                    //把最新数组追加到旧数据前面
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObjectsFromArray:muarr];
                    [tempArray addObjectsFromArray:self.bookListArr];
                    self.bookListArr = tempArray;
                    
                }else{
                    self.bookListArr = muarr;
                }
            }
            [self.collectionView reloadData];
            
        }else if (404 == [responseObject[@"code"] integerValue]){
            //重新登陆
            
        }else if (400 == [responseObject[@"code"] integerValue]){
            HZLog(@"没有数据了,已是最新");
            
        }else{
            
        }
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma --mark 读书的代理
- (void)saveShowDetailCell:(CHZCollectionViewCell *)cell{
    
    if (self.cell != cell ) {
        if (self.cell.isShowDetail) {
            [self.cell endShowDetail];
            
        }
        self.cell = cell;
    }
    
}
//文字详情
- (void)bookTextBtnClick:(CHZBookVideo *)cellData{
    /*
     - (void)bookTextPush:(CHZBookVideo *)cellData;
     - (void)bookMusicPush:(CHZBookVideo *)cellData;
     - (void)bookVideoPush:(CHZBookVideo *)cellData;
     */
    
    if ([self.delegate respondsToSelector:@selector(bookTextPush:)]) {
        [self.delegate bookTextPush:cellData];
    }
}
//music详情
-(void)bookMusicBtnClick:(CHZBookVideo *)cellData{
    if ([self.delegate respondsToSelector:@selector(bookMusicPush:)]) {
        [self.delegate bookMusicPush:cellData];
    }
    
}
//video详情
- (void)bookVideoBtnClick:(CHZBookVideo *)cellData{
    if ([self.delegate respondsToSelector:@selector(bookVideoPush:)]) {
        [self.delegate bookVideoPush:cellData];
    }
}



#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.bookListArr.count;
    //return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHZBookVideo *bookTemp = self.bookListArr[indexPath.row];
    CHZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    [cell setBookVideoData:bookTemp];
    cell.delegate = self;
    return cell;
}


#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cell == cell) {
        if (self.cell.isShowDetail) {
            [self.cell endShowDetail];   
        }
    }
}



@end
