//
//  CHZCollectionViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZCollectionViewController.h"
#import "CHZSharedCollectionViewCell.h"
#import "CHZTitleName.h"
#import "CHZSaveSharedData.h"
#import "CHZNoticeModel.h"
#import "CHZArticleDetailViewController.h"
#import "CHZNoticeViewController.h"



@interface CHZCollectionViewController ()<CHZSharedCollectionViewCellDelegate>

@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (nonatomic,strong) NSMutableDictionary<NSString* ,CHZSaveSharedData* >* dataSources_dic;

@end

@implementation CHZCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)setItemArr:(NSArray<CHZTitleName *> *)itemArr{
    _itemArr = itemArr;
    
    if (self.dataSources_dic == nil) {
        self.dataSources_dic = [NSMutableDictionary dictionary];
        for (CHZTitleName* curMenuItem in itemArr) {
            CHZSaveSharedData *postBackItem = [CHZSaveSharedData saveSharedDataWith:nil nameId:curMenuItem.nameId];
            [self.dataSources_dic setObject:postBackItem forKey:curMenuItem.nameId];
        }
    }
    for (int i=0; i<1000; i++) {
        CHZNoticeViewController*vc= [[CHZNoticeViewController alloc] init];
        vc.view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    }
    
    
    [self.collectionView reloadData];

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
    
    [self.collectionView registerClass:[CHZSharedCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.pagingEnabled = YES;

}



- (void)setupData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
//    params[@"page"] = @"";
    
    
    [self.mgr POST:API_ARTLIST parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"请求标题名字成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.itemArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CHZTitleName *titleName = self.itemArr[indexPath.row];
    NSDictionary *curDict = [self getCurDictWith:titleName.nameId];
    CHZSharedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    [cell endRefreshCurCell];
    cell.delegate = self;
    [cell configurationPostBackDictionary:titleName dictData:curDict];
    
    
    return cell;
}

- (NSDictionary *)getCurDictWith:(NSString *)titleId{
    
    CHZSaveSharedData* resultItem = [self.dataSources_dic objectForKey:titleId];

    return [NSDictionary dictionaryWithObjectsAndKeys:resultItem,titleId, nil];
}

#pragma mark <UICollectionViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    _isTouchSliding = NO;
    NSInteger index = scrollView.contentOffset.x / kScreenSize.width;
    if ([self.delegate respondsToSelector:@selector(ScrollViewDidEndWithIndex:)]) {
        [self.delegate ScrollViewDidEndWithIndex:index];
    }
}



- (void)beginRefreshWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    CHZSharedCollectionViewCell *curCell = (CHZSharedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [curCell beginRefreshCurCell];
}

//cell的代理方法
- (void)artcleListDataWithCell:(CHZSharedCollectionViewCell *)cell dictData:(NSDictionary<NSString *,CHZSaveSharedData *> *)dict{
    NSString* needUpdateListToken = [[dict allKeys] lastObject];
    CHZSaveSharedData *postBackItem = [[dict allValues] lastObject];
    [self.dataSources_dic setValue:postBackItem forKey:needUpdateListToken];
}

- (void)artclePushDetailView:(CHZSharedCollectionViewCell *)cCell andTableVCell:(UITableViewCell *)tCell andPushVC:(CHZArticleDetailViewController *)VC{
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)updateNum:(NSUInteger)num{
    if ([self.delegate respondsToSelector:@selector(updateCellNum:)]) {
        [self.delegate updateCellNum:num];
    }
}

#pragma --mark 公告点击
- (void)clickToNotice:(NSString *)nId{
    if ([self.delegate respondsToSelector:@selector(noticeADWebVIew:)]) {
        [self.delegate noticeADWebVIew:nId];
    }
    
}

- (void)TokenPass{
    if ([self.delegate respondsToSelector:@selector(TokenMessage:)]) {
        [self.delegate TokenMessage:704];
    }
}

- (void)noMoneyGoBack{
    if ([self.delegate respondsToSelector:@selector(TokenMessage:)]) {
        [self.delegate TokenMessage:705];
    }
}



/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
