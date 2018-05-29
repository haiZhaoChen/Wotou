//
//  CHZSharedMainViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZSharedMainViewController.h"
#import "CHZShareBar.h"
#import "CHZSharedTableViewCell.h"
#import "CHZCollectionViewController.h"
#import "CHZTitleName.h"
#import "CHZNoticeViewController.h"
#import "CHZGlobalInstance.h"
#import "CHZBookMusViewController.h"


@interface CHZSharedMainViewController ()<CHZSharedTableViewCellDelegate,CHZCollectionViewControllerDelegate>

@property (nonatomic, strong)CHZSharedTableViewCell *shareBar;
@property (nonatomic, strong)CHZCollectionViewController *collecVC;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong)NSArray<CHZTitleName *> *itemArr;

//动画
@property (strong, nonatomic)UIImageView *imgView;

@end

@implementation CHZSharedMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"窝头学堂";
    
    self.currentIndex = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"artList" ofType:@"plist"];
    
    NSArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArr) {
        CHZTitleName *titleName = [[CHZTitleName alloc] initWithDict:dict];
        [tempArr addObject:titleName];
    }
    
    self.itemArr = tempArr;
    
    [self setupHeaderView];
    
    //设置页面
    [self setupCollectView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([CHZGlobalInstance shareInstance].isPlaying) {
        self.navigationItem.titleView = self.imgView;
        self.navigationItem.titleView.userInteractionEnabled = YES;
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        basicAnimation.duration = 5;
        basicAnimation.fromValue = [NSNumber numberWithInt:0];
        basicAnimation.toValue = [NSNumber numberWithInt:M_PI*2];
        [basicAnimation setRepeatCount:NSIntegerMax];
        [basicAnimation setAutoreverses:NO];
        [basicAnimation setCumulative:YES];
        [_imgView.layer addAnimation:basicAnimation forKey:@"basicAnimation"];
    }else{
        self.navigationItem.titleView= nil;
        self.navigationItem.title = @"窝头学堂";
    }
}
- (void)titleViewBtnClick{
    
    [self.navigationController pushViewController:[CHZBookMusViewController shareBookMusViewController] animated:YES];
    
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musicGloble"]];
        _imgView.frame = CGRectMake(0, 0, 32, 32);
        _imgView.userInteractionEnabled = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _imgView.bounds;
        [_imgView addSubview:btn];
        [btn addTarget:self action:@selector(titleViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _imgView;
}

//退出应用
- (void)TokenMessage:(NSUInteger)code{
    switch (code) {
        case 704:
            [CHZLoginOutViewController logout:self];
            break;
        case 705:
            [CHZLoginOutViewController logoutNoMoney:self];
            break;
        default:
            break;
    }
}

- (void)setupHeaderView{
    
    self.shareBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHZSharedTableViewCell class]) owner:self options:nil] firstObject];
    self.shareBar.frame = CGRectMake(0, 0,self.view.size.width,self.shareBar.height);
    self.shareBar.delegate = self;
    [self.view addSubview:self.shareBar];
}

//加载collectView
- (void)setupCollectView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.itemSize = CGSizeMake(kScreenSize.width, kScreenSize.height - CGRectGetMaxY(self.shareBar.frame) -49 -64);
    HZLog(@"%@",NSStringFromCGSize(layout.itemSize));
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.collecVC = [[CHZCollectionViewController alloc] initWithCollectionViewLayout:layout];
    
    [self addChildViewController:self.collecVC];
    
    self.collecVC.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.shareBar.frame), kScreenSize.width, KHEIGHT- CGRectGetMaxY(self.shareBar.frame));
    self.collecVC.collectionView.backgroundColor = CHZGlobalBg;
    self.collecVC.delegate = self;
    
    self.collecVC.itemArr = self.itemArr;
    
    [self.view addSubview:self.collecVC.collectionView];
   

}


#pragma 实现刷新时的新动态的提示条,代理方法实现
- (void)updateCellNum:(NSUInteger)num{
    //[self showNewStatusBar:num];
}

- (void)showNewStatusBar:(NSUInteger)count{
    //添加到导航栏下面
    UIButton *btn = [[UIButton alloc] init];
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    //设置btn属性
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage resizedImage:@"nav"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //设置数据
    if (count) {
        [btn setTitle:[NSString stringWithFormat:@"有%lu条新动态已经更新",(unsigned long)count] forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"没有新动态数据" forState:UIControlStateNormal];
    }
    
    //设置尺寸
    CGFloat btnH = 35;
    CGFloat btnX = 0;
    CGFloat btnY = 64 - btnH;
    CGFloat btnW = self.view.frame.size.width;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    //添加动画
    [UIView animateWithDuration:1 animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, btnY+1);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.7 delay:1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            //取消transform设置
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [btn removeFromSuperview];
        }];
        
    }];
    
    
}


- (void)titleBtnClickWithIndex:(NSInteger)index{
    _currentIndex = index;
    [self.collecVC.collectionView setContentOffset:CGPointMake(index * kScreenSize.width, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ScrollViewDidEndWithIndex:(NSInteger)index{
    _currentIndex = index;
    [self.shareBar scrollToCenterWithIndex:index];
}

- (void)noticeADWebVIew:(NSString *)nId{
    CHZNoticeViewController *noticeVC = [[CHZNoticeViewController alloc] initWithCId:nId];
    [self.navigationController pushViewController:noticeVC animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
