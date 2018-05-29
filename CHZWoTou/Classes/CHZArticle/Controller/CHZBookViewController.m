//
//  CHZBookViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookViewController.h"
#import "CHZBookTitleTableViewCell.h"
#import "CHZArticleTableViewController.h"
#import "CHZBookCollectionViewController.h"
#import "CHZBookTextDetailViewController.h"
#import "CHZBookMusViewController.h"
#import "CHZBookVideoDetailViewController.h"
#import "CHZInterviewCollectionViewController.h"
#import "CHZArticleReadViewController.h"
#import "CHZGlobalInstance.h"

@interface CHZBookViewController ()<CHZBookTitleTableViewCellDelegate,UIScrollViewDelegate,CHZCollectionViewForDetailDelegate,InterviewCollectionViewControllerDelegate,ArticleTableViewDelegate>

@property (nonatomic, strong)CHZBookTitleTableViewCell *shareBar;

@property (nonatomic,strong) NSArray *controllers;

//动画
@property (strong, nonatomic)UIImageView *imgView;


/**
 *  scrollView
 */
@property (nonatomic, weak)UIScrollView *scrollView;

@end

@implementation CHZBookViewController

- (instancetype)init{
    if (self = [super init]) {
        CHZArticleTableViewController *art = [[CHZArticleTableViewController alloc] init];
        
        art.delegate = self;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake((kScreenSize.width-5)*0.5, (kScreenSize.width-5)*0.6);
        HZLog(@"%@",NSStringFromCGSize(layout.itemSize));
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 49, 2);
        
        CHZBookCollectionViewController *book = [[CHZBookCollectionViewController alloc] initWithCollectionViewLayout:layout];

        book.delegate = self;
        
        UICollectionViewFlowLayout *layoutInterview = [[UICollectionViewFlowLayout alloc] init];
        [layoutInterview setScrollDirection:UICollectionViewScrollDirectionVertical];
        layoutInterview.itemSize = CGSizeMake((kScreenSize.width-5)*0.5, (kScreenSize.width-5)*0.6);
        HZLog(@"%@",NSStringFromCGSize(layoutInterview.itemSize));
        layoutInterview.minimumLineSpacing = 1;
        layoutInterview.minimumInteritemSpacing = 1;
        layoutInterview.sectionInset = UIEdgeInsetsMake(2, 2, 49, 2);
        
        CHZInterviewCollectionViewController *interviewVC = [[CHZInterviewCollectionViewController alloc] initWithCollectionViewLayout:layoutInterview];
        
        interviewVC.delegate = self;
        
        self.controllers =  @[art,book,interviewVC];
        
        [self addChildViewController:art];
        [self addChildViewController:interviewVC];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSelf];
    
    [self addContentView];
    
 
}

- (void)setSelf{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationItem.title = @"窝头学堂";
    
    self.view.backgroundColor = [UIColor whiteColor];
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
        UIImage *image = [UIImage imageNamed:@"Avast"];
        for (int i= 0; i>100; i++) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"urlss%d",arc4random()] toDisk:YES];
        }
    }else{
        self.navigationItem.titleView= nil;
        self.navigationItem.title = @"窝头学堂";
    }
}
- (void)titleViewBtnClick{
    [self.navigationController pushViewController:[CHZBookMusViewController shareBookMusViewController] animated:YES];
}

//图片旋转
//懒加载
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

- (void)addContentView{
    
    self.shareBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHZBookTitleTableViewCell class]) owner:self options:nil] firstObject];
    self.shareBar.frame = CGRectMake(0, 0,self.view.size.width,self.shareBar.height);
    self.shareBar.delegate = self;

    [self.view addSubview:self.shareBar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareBar.frame), kScreenSize.width, kScreenSize.height - CGRectGetMaxY(self.shareBar.frame) - 49)];
    scrollView.contentSize = CGSizeMake(kScreenSize.width * _controllers.count, 0);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView = scrollView;
    [self.view addSubview:_scrollView];
    
    for (UIViewController *childVC in _controllers) {
        NSInteger index = [_controllers indexOfObject:childVC];
        childVC.view.frame = CGRectMake(kScreenSize.width * index, 0, kScreenSize.width, CGRectGetHeight(_scrollView.frame));
        [_scrollView addSubview:childVC.view];
    }
}

- (void)titleBtnClickWithIndex:(NSInteger)index{
    [_scrollView setContentOffset:CGPointMake(kScreenSize.width * index, 0) animated:YES];
}


//scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kScreenSize.width;
    [self.shareBar scrollToCenterWithIndex:index];
}




#pragma --mark 读书的代理
- (void)bookTextPush:(CHZBookVideo *)cellData{
    HZLog(@"push to text detail view");
    CHZBookTextDetailViewController *bookDetailVC = [[CHZBookTextDetailViewController alloc] initWithBookVideo:cellData];
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
}
- (void)bookMusicPush:(CHZBookVideo *)cellData{
    HZLog(@"push to music detail view");
    CHZBookMusViewController *bookDetailVC = [CHZBookMusViewController shareBookMusViewController];
    bookDetailVC.cellData = cellData;
    
    [self.navigationController pushViewController:bookDetailVC animated:YES];
}
- (void)bookVideoPush:(CHZBookVideo *)cellData{
    HZLog(@"push to video detail view");
    
    CHZBookVideoDetailViewController *bookDetailVC = [[CHZBookVideoDetailViewController alloc] initWithBookVideo:cellData];
    
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
}

- (void)interviewTextPush:(CHZinterviewModel *)cellData{
    HZLog(@"push to text detail view");
    CHZBookTextDetailViewController *bookDetailVC = [[CHZBookTextDetailViewController alloc] initWithBookInterview:cellData];
    
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
}
- (void)interviewMusicPush:(CHZinterviewModel *)cellData{
    HZLog(@"push to music detail view");
    CHZBookMusViewController *bookDetailVC = [CHZBookMusViewController shareBookMusViewController];
    bookDetailVC.interviewData = cellData;
    
    [self.navigationController pushViewController:bookDetailVC animated:YES];
}
- (void)interviewVideoPush:(CHZinterviewModel *)cellData{
    HZLog(@"push to video detail view");
    
    CHZBookVideoDetailViewController *bookDetailVC = [[CHZBookVideoDetailViewController alloc] initWithBookInterview:cellData];
    
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
}



- (void)articleReadPush:(CHZBookArticle *)cellData{
    CHZArticleReadViewController *articleReadVC = [[CHZArticleReadViewController alloc] initWithCellData:cellData];
    
    [self.navigationController pushViewController:articleReadVC animated:YES];
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

@end
