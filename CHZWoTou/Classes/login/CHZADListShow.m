//
//  CHZADListShow.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZADListShow.h"

#define BOTTOMVIEW_HEIGHT 50
#define TITLE_HEIGHT 30
#define PAGECONTROLLER_WIDTH 60

@interface CHZADListShow()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageController;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CHZADListShow

- (void)setUrlList:(NSArray *)urlList{
    _urlList = urlList;
    NSInteger arrayCount = urlList.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * arrayCount, CGRectGetHeight(self.frame));
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-PAGECONTROLLER_WIDTH-16, CGRectGetHeight(self.frame)-TITLE_HEIGHT, PAGECONTROLLER_WIDTH, TITLE_HEIGHT)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = arrayCount;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    
    self.pageController = pageControl;
    [self addSubview:pageControl];
    
    CGFloat imageViewWidth = CGRectGetWidth(scrollView.frame);
    CGFloat imageViewHeight = CGRectGetHeight(scrollView.frame);
    
    for (int i = 0; i < arrayCount; i++) {
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth * i, 0, imageViewWidth, imageViewHeight)];
        imgview.backgroundColor = [UIColor lightGrayColor];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds = YES;
        [imgview sd_setImageWithURL:urlList[i]];
        [scrollView addSubview:imgview];
        
    }
    if (arrayCount > 1) {
        if(!self.timer) {
            self.timer = [NSTimer timerWithTimeInterval:4.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
        }
    }

}


#pragma mark - 自动滚动
- (void)scrollToNextPage:(NSTimer *)timer
{
    _currentIndex++;
    if (_currentIndex >= _urlList.count) {
        _currentIndex = 0;
    }
    _pageController.currentPage = _currentIndex;
    [_scrollView setContentOffset:CGPointMake(_currentIndex*CGRectGetWidth(_scrollView.frame), 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
    _pageController.currentPage = _currentIndex;
}




@end
