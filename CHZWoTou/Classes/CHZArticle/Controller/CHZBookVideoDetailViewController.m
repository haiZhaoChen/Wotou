//
//  CHZBookVideoDetailViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/28.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookVideoDetailViewController.h"
#import "CHZBookVideo.h"
#import "CHZinterviewModel.h"
#import "MoviePlayer.h"
#import "OSCPopInputView.h"
#import "CHZBookVideoModel.h"
#import "CHZCommentsListTableViewController.h"
#import "ZXVideoPlayerController.h"
#import "ZXVideo.h"
#import "ZXVideoPlayerControlView.h"


@interface CHZBookVideoDetailViewController ()<UIWebViewDelegate,OSCPopInputViewDelegate,videoPlayerControllerDelegate>
//评论
@property (weak, nonatomic) IBOutlet UIButton *commenBtn;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) OSCPopInputView *inputView;
//软键盘size
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

//标头
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *readNumLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UILabel *commentNunmLB;
@property (weak, nonatomic) IBOutlet UIView *comView;
@property (weak, nonatomic) IBOutlet UIView *topView;

//数据
@property (nonatomic, strong)CHZBookVideo *cellData;
@property (nonatomic, strong)CHZinterviewModel *interviewData;
@property (nonatomic, strong)CHZBookVideoModel *videoM;

//web
@property (nonatomic, strong)UIWebView *webVIewLoad;

@property (nonatomic,strong)AFHTTPSessionManager *mgr;
@property (nonatomic,strong)ZXVideoPlayerController *movieView;
@property (nonatomic,strong)ZXVideo *videoData;


//10秒内不能发评论
@property (nonatomic,assign)BOOL isCanPushComents;

@end

@implementation CHZBookVideoDetailViewController

- (ZXVideo *)videoData{
    if (!_videoData) {
        _videoData = [[ZXVideo alloc] init];
    }
    return _videoData;
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








- (instancetype)initWithBookVideo:(CHZBookVideo *)cellData{
    if (self = [super init]) {
        _cellData = cellData;
    }
    return self;
}

- (instancetype)initWithBookInterview:(CHZinterviewModel *)interviewData{
    if (self = [super init]) {
        _interviewData = interviewData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.hidesBarsWhenVerticallyCompact = YES;
    self.view.backgroundColor = CHZGlobalBg;
//    self.navigationItem.title = @"经典图书";
    // Do any additional setup after loading the view from its nib.
    self.commenBtn.layer.masksToBounds = YES;
    self.commenBtn.layer.cornerRadius = 5.0;
    //self.commenBtn.layer.borderColor = [UIColor blackColor];
    
    self.commenBtn.layer.borderWidth = 1.0f;
    
    self.commenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [self setVideoView];
    
    [self setupTheData];
    
    //软键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientChange:(NSNotification *)noti {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            if (!self.movieView.isFullscreenMode) {
                return;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(0);
                self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
                
                
            }];
            
            
            
            if ([UIApplication sharedApplication].statusBarHidden) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.hidden = NO;
                self.webVIewLoad.hidden = NO;
                self.comView.hidden = NO;
                self.topView.hidden = NO;
//                CGRect newFrame = self.view.frame;
//                newFrame.origin.y += 64;
                CGRect tabFrame = self.comView.frame;
                tabFrame.origin.y -= 64;
                self.comView.frame = tabFrame;
                
                HZLog(@"%@==%@==%@",NSStringFromCGRect(self.topView.frame),NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.comView.frame));
                self.movieView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, kScreenWidth *0.55);
                self.movieView.isFullscreenMode = NO;
                self.movieView.videoControl.fullScreenButton.hidden = NO;
                self.movieView.videoControl.shrinkScreenButton.hidden = YES;
            });
            
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }];
            
            if (self.movieView.isFullscreenMode) {
                return;
            }
            
            if (self.movieView.videoControl.isBarShowing) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            } else {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.movieView.frame = CGRectMake(0, 0, kScreenHeight,kScreenWidth);
                UIImage *image = [UIImage imageNamed:@"Avast"];
                for (int i= 0; i>100; i++) {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"urlss%d",arc4random()] toDisk:YES];
                }
                self.movieView.isFullscreenMode = YES;
                self.movieView.videoControl.fullScreenButton.hidden = YES;
                self.movieView.videoControl.shrinkScreenButton.hidden = NO;
                
                self.navigationController.navigationBar.hidden = YES;
                self.webVIewLoad.hidden = YES;
                self.comView.hidden = YES;
                self.topView.hidden = YES;
            });

        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            
            
            if (self.movieView.isFullscreenMode) {
                return;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                self.view.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
            }];
            
            if (self.movieView.videoControl.isBarShowing) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            } else {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.movieView.frame = CGRectMake(0, 0, kScreenHeight,kScreenWidth);
                
                self.movieView.isFullscreenMode = YES;
                self.movieView.videoControl.fullScreenButton.hidden = YES;
                self.movieView.videoControl.shrinkScreenButton.hidden = NO;
                
                self.navigationController.navigationBar.hidden = YES;
                self.webVIewLoad.hidden = YES;
                self.comView.hidden = YES;
                self.topView.hidden = YES;
            });
        }
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotate{
    return YES;
}
//横竖屏

- (void)fullScreenBtnClick{
//    [self changeToOrientation:UIDeviceOrientationLandscapeLeft];
}
- (void)unFullScreenBtnClick{
//    [self changeToOrientation:UIDeviceOrientationPortrait];
}

- (void)changeToOrientation:(UIDeviceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//- (void)deviceOrientationDidChange
//{
//    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
//    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//        [self orientationChange:NO];
//        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
//    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//        [self orientationChange:YES];
//    }
//}
//
//- (void)orientationChange:(BOOL)landscapeRight
//{
//    if (landscapeRight) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//            self.view.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//        }];
//    } else {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(0);
//            self.view.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//        }];
//    }
//}






- (void)setVideoView{

    self.movieView = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), kScreenWidth, kScreenWidth *0.55)];
    self.movieView.delegate = self;
    __weak typeof(self) weakSelf = self;
    self.movieView.videoPlayerGoBackBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
        [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
        
        strongSelf.movieView = nil;
    };
    
    self.movieView.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
        NSLog(@"切换为竖屏模式");
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.navigationController.navigationBar.hidden = NO;
        strongSelf.webVIewLoad.hidden = NO;
        strongSelf.comView.hidden = NO;
        strongSelf.topView.hidden = NO;
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//            [strongSelf orientationChange:YES];
        }
    };
    self.movieView.videoPlayerWillChangeToFullScreenModeBlock = ^(){
        __strong typeof(self) strongSelf = weakSelf;
        NSLog(@"切换为横屏模式");
        strongSelf.navigationController.navigationBar.hidden = YES;
        strongSelf.webVIewLoad.hidden = YES;
        strongSelf.comView.hidden = YES;
        strongSelf.topView.hidden = YES;
    };
    
    [self.movieView showInView:self.view];

    
    
    _webVIewLoad = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_movieView.view.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(_movieView.view.frame) - 49-64)];
    _webVIewLoad.backgroundColor = [UIColor whiteColor];
    _webVIewLoad.delegate = self;
    
    [self.view addSubview:_webVIewLoad];
}





- (void)setupTheData{
    if (_cellData) {
        self.navigationItem.title = [NSString stringWithFormat:@"学堂"];
        self.titleName.text = _cellData.book_name;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"aid"] = _cellData.bookId;
        params[@"uid"] = params[@"id"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        [self.mgr POST:API_BOOKVideo parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                
                if (responseObject[@"data"] != [NSNull null]) {
                    
                    _videoM = [[CHZBookVideoModel alloc] initWithDict:responseObject[@"data"]];
                    
                    NSURL *url = [NSURL URLWithString:_videoM.mp4_content];
                    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                    [request setHTTPMethod: @"POST"];
                    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.readNumLB.text = _videoM.read_counts;
                        self.timeLB.text = _videoM.add_time;
                        self.commentNunmLB.text = _videoM.comments;
                        
                        [self.webVIewLoad loadRequest:request];
                        
                        self.videoData.title = _videoM.book_name;
                        self.videoData.playUrl = _videoM.mp4;
                        _movieView.video = _videoData;
                        
                    });
                    
                    
                    
                }else{
                    [SVProgressHUD dismiss];
                }
            }else if (704 == [responseObject[@"code"] integerValue]){
                //token过期
                [CHZLoginOutViewController logout:self];
                
            }else if(705 == [responseObject[@"code"] integerValue]){
                [CHZLoginOutViewController logoutNoMoney:self];
            }else{
                [SVProgressHUD dismiss];
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            
            HZLog(@"%@",error);
        }];

        
    }else if (_interviewData){
        self.navigationItem.title = [NSString stringWithFormat:@"访谈"];
        self.titleName.text = _interviewData.title;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"aid"] = _interviewData.interviewId;
        params[@"uid"] = params[@"id"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        [self.mgr POST:API_INTERVIEWVIDEO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                
                if (responseObject[@"data"] != [NSNull null]) {
                    
                    _videoM = [[CHZBookVideoModel alloc] initWithDict:responseObject[@"data"]];
                    
                    NSURL *url = [NSURL URLWithString:_videoM.mp4_content];
                    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                    [request setHTTPMethod: @"POST"];
                    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.readNumLB.text = _videoM.read_counts;
                        self.timeLB.text = _videoM.add_time;
                        self.commentNunmLB.text = _videoM.comments;
                        
                        [self.webVIewLoad loadRequest:request];
                        self.videoData.title = _videoM.book_name;
                        self.videoData.playUrl = _videoM.mp4;
                        _movieView.video = _videoData;
                        
                    });
                    
                    
                }else{
                    [SVProgressHUD dismiss];
                }
            }else if (704 == [responseObject[@"code"] integerValue]){
                //token过期
                [CHZLoginOutViewController logout:self];
                
            }else if(705 == [responseObject[@"code"] integerValue]){
                [CHZLoginOutViewController logoutNoMoney:self];
            }else{
                [SVProgressHUD dismiss];
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            
            HZLog(@"%@",error);
        }];

        
    }else{
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.movieView stop];
    [self.movieView.view removeFromSuperview];
    self.movieView = nil;
    
}

#pragma --mark web 代理
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"页面加载失败"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    
}



- (IBAction)commentListClick:(id)sender {
    if (_cellData) {
        CHZCommentsListTableViewController *comVC = [[CHZCommentsListTableViewController alloc] initWithStyle:UITableViewStylePlain aid:_videoM.musId count:_videoM.comments type:2];
        [self.navigationController pushViewController:comVC animated:YES];
    }else if(_interviewData){
        CHZCommentsListTableViewController *comVC = [[CHZCommentsListTableViewController alloc] initWithStyle:UITableViewStylePlain aid:_videoM.musId count:_videoM.comments type:3];
        [self.navigationController pushViewController:comVC animated:YES];
    }else{
        
    }
}
- (IBAction)commentBtnClick:(id)sender {
    [self showEditView];
}
- (IBAction)returnBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showEditView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _backView = [[UIView alloc] initWithFrame:window.bounds];
    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [_backView addSubview:self.inputView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBackWithGR:)];
    [_backView addGestureRecognizer:tapGR];
    [self.inputView activateInputView];
    [window addSubview:_backView];
}

- (void)touchBackWithGR:(UITapGestureRecognizer *)tapGR{
    CGPoint touchPoint = [tapGR locationInView:_backView];
    CGRect rect = CGRectMake(0, 0, kScreenSize.width, CGRectGetMinY(self.inputView.frame));
    if (CGRectContainsPoint(rect, touchPoint)) {
        [self hideEditView];
    }
}

- (void)hideEditView{
    [self.inputView freezeInputView];
    [UIView animateWithDuration:0.3 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.inputView.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, kScreenSize.height / 3) ;
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
    }];
}

- (OSCPopInputView *)inputView{
    if(!_inputView){
        _inputView = [OSCPopInputView popInputViewWithFrame:CGRectMake(0, kScreenSize.height, kScreenSize.width, kScreenSize.height *0.33) maxStringLenght:160 delegate:self autoSaveDraftNote:YES];
    }
    return _inputView;
}



- (void)keyboardDidShow:(NSNotification *)nsNotification
{
    NSDictionary *userInfo = [nsNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:1 animations:^{
        self.inputView.frame = CGRectMake(0, kScreenSize.height - CGRectGetHeight(self.inputView.frame) - _keyboardHeight, kScreenSize.width, CGRectGetHeight(self.inputView.frame));
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHiden:)];
    [self.view addGestureRecognizer:_tap];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self hideEditView];
}

#pragma mark - 软键盘隐藏
- (void)keyBoardHiden:(UITapGestureRecognizer *)tap
{
    [_inputView endEditing];
    [self.view removeGestureRecognizer:_tap];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}


#pragma --mark 点击评论按钮
- (void)popInputViewClickDidSendButton:(OSCPopInputView *)popInputView curTextView:(UITextView *)textView{
    
    //判断是否在10秒内
    if (self.isCanPushComents) {
        [SVProgressHUD showInfoWithStatus:@"您发送评论太频繁了"];
        return;
    }
    
    if (textView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"评论内容不能为空!"];
        return;
    }
    
    if (_cellData) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"bid"] = _cellData.bookId;
        params[@"uid"] = params[@"id"];
        params[@"content"] = textView.text;
        [SVProgressHUD show];
        [self.mgr POST:API_BOOKCOMMENTS parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                
                //判断10秒内
                self.isCanPushComents = YES;
                [self timeOutPush];
                
                [self.inputView clearDraftNote];
                [self hideEditView];
            }else if (704 == [responseObject[@"code"] integerValue]){
                //token过期
                [CHZLoginOutViewController logout:self];
                
            }else if(705 == [responseObject[@"code"] integerValue]){
                [CHZLoginOutViewController logoutNoMoney:self];
            }else if(400 == [responseObject[@"code"] integerValue]){
                [SVProgressHUD dismiss];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * PH = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alert addAction:PH];
                
                alert.popoverPresentationController.sourceView = self.view;
                alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"回复失败，稍后再试"];
        }];
    }else if(_interviewData){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"bid"] = _interviewData.interviewId;
        params[@"uid"] = params[@"id"];
        params[@"content"] = textView.text;
        [SVProgressHUD show];
        [self.mgr POST:API_INTERVIEWCOMMENTS parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                
                //判断10秒内
                self.isCanPushComents = YES;
                [self timeOutPush];
                
                [self.inputView clearDraftNote];
                [self hideEditView];
            }else if (704 == [responseObject[@"code"] integerValue]){
                //token过期
                [CHZLoginOutViewController logout:self];
                
            }else if(705 == [responseObject[@"code"] integerValue]){
                [CHZLoginOutViewController logoutNoMoney:self];
            }else if(400 == [responseObject[@"code"] integerValue]){
                [SVProgressHUD dismiss];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * PH = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alert addAction:PH];
                
                alert.popoverPresentationController.sourceView = self.view;
                alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"回复失败，稍后再试"];
        }];
        
    }else{
        
    }
    
    
}

//计时器拦截
- (void)timeOutPush{
    // 倒计时时间
    __block NSInteger timeOut = 10;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isCanPushComents = NO;
            });
            
        }else{
            
            timeOut--;
        }
    });
    
    dispatch_resume(timer);
    
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
