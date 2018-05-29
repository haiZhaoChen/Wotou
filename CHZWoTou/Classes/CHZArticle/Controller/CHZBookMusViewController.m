//
//  CHZBookMusViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/27.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookMusViewController.h"
#import "CHZBookVideo.h"
#import "CHZinterviewModel.h"
#import "CHZBookMusModel.h"
#import "STKAudioPlayer.h"
#import "UIImage+Blur.h"
#import "OSCPopInputView.h"
#import "CHZCommentsListTableViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "CHZGlobalInstance.h"


@interface CHZBookMusViewController ()<UIWebViewDelegate,UIScrollViewDelegate,STKAudioPlayerDelegate,UINavigationControllerDelegate,OSCPopInputViewDelegate>
//音乐播放需要
@property (nonatomic,strong)CABasicAnimation *basicAnimation;

@property (weak, nonatomic) IBOutlet UISlider *musSlider;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)NSInteger durMin;
@property(nonatomic,assign)NSInteger durSec;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLable;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (nonatomic, assign)BOOL played;

@property (weak, nonatomic) IBOutlet UIImageView *bgViewForMus;
@property (weak, nonatomic) IBOutlet UIImageView *musBgImg;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

//评论
@property (weak, nonatomic) IBOutlet UIButton *commenBtn;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) OSCPopInputView *inputView;
//软键盘size
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, assign) NSInteger selectIndexPath;


//数据
//@property (nonatomic, strong)CHZBookVideo *cellData;
//@property (nonatomic, strong)CHZinterviewModel *interviewData;
//头图
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *readLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *sharedLB;

@property (weak, nonatomic) IBOutlet UIWebView *webVIewLoad;

@property (nonatomic, strong)CHZBookMusModel *musM;


@property (nonatomic,strong)AFHTTPSessionManager *mgr;
//10秒内不能发评论
@property (nonatomic,assign)BOOL isCanPushComents;

@end

@implementation CHZBookMusViewController

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}

//- (instancetype)initWithBookVideo:(CHZBookVideo *)cellData{
//    if (self = [super init]) {
//        _cellData = cellData;
//        
//    }
//    return self;
//}
- (instancetype)initWithBookInterview:(CHZinterviewModel *)interviewData{
    if (self = [super init]) {
        _interviewData = interviewData;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = CHZGlobalBg;
    // Do any additional setup after loading the view from its nib.
    self.commenBtn.layer.masksToBounds = YES;
    self.commenBtn.layer.cornerRadius = 5.0;
    //self.commenBtn.layer.borderColor = [UIColor blackColor];
    
    self.commenBtn.layer.borderWidth = 1.0f;
    
    self.commenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [self setTheLoad];
    [self getCellData];
    
    [self createNotification];
    
    //软键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

// 创建通知
- (void)createNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificaitonAction:)
                                                 name:@"UIEventSubtype"
                                               object:nil];
    
    //处理中断事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
}



-(void)setTheLoad{
    
    self.webVIewLoad.delegate = self;
    
    self.player = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = YES, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    
    
    self.player.delegate = self;
    self.player.volume = 0.5;
    [self.musSlider setThumbImage:[UIImage imageNamed:@"iconYuanYuan"] forState:UIControlStateNormal];
    [self.musSlider setThumbImage:[UIImage imageNamed:@"iconYuanYuan"] forState:UIControlStateHighlighted];
    
    [self.bgViewForMus setImage:[[UIImage imageNamed:@"bgmeitu"] boxblurImageWithBlur:1]];
    
    
    if (_interviewData) {
        [self.musBgImg sd_setImageWithURL:[NSURL URLWithString:_interviewData.thumbnail] placeholderImage:[UIImage imageNamed:@"bookFind"]];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"页面加载失败"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    // 设置后台播放时显示的东西，例如歌曲名字，图片
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:self.musBgImg.image];
    
    NSDictionary *dic = @{MPMediaItemPropertyTitle:self.navigationItem.title,      // 歌曲名
                          MPMediaItemPropertyArtwork:artWork,              // 海报
                          MPMediaItemPropertyAlbumTitle:@"窝头学堂"
                          };
    // 进行锁频音乐信息设置
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];

    
    
    
}

- (void)setInterviewData:(CHZinterviewModel *)interviewData{
    if (!(self.interviewData.interviewId == interviewData.interviewId)) {
        _interviewData = interviewData;
        
        [self.player stop];
        self.navigationItem.title = [NSString stringWithFormat:@"访谈"];
        self.titleName.text = _interviewData.title;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"aid"] = _interviewData.interviewId;
        params[@"uid"] = params[@"id"];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        [self.mgr POST:API_INTERVIEWMP3 parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                
                if (responseObject[@"data"] != [NSNull null]) {
                    
                    _musM = [[CHZBookMusModel alloc] initWithDict:responseObject[@"data"]];
                    
                    NSURL *url = [NSURL URLWithString:_musM.mp3_content];
                    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                    [request setHTTPMethod: @"POST"];
                    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.readLB.text = _musM.read_counts;
                        self.timeLB.text = _musM.add_time;
                        self.sharedLB.text = _musM.comments;
                        
                        [self.webVIewLoad loadRequest:request];
                    });
                    
                    
                    
                }else{
                    [SVProgressHUD dismiss];
                }
            }else if (704 == [responseObject[@"code"] integerValue]){
                //token过期
                [SVProgressHUD dismiss];
                [CHZLoginOutViewController logout:self];
                
            }else if(705 == [responseObject[@"code"] integerValue]){
                [SVProgressHUD dismiss];
                [CHZLoginOutViewController logoutNoMoney:self];
            }else{
                [SVProgressHUD dismiss];
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            
            HZLog(@"%@",error);
        }];

    }
    
}
- (void)setCellData:(CHZBookVideo *)cellData{
    
    if (!(self.cellData.bookId == cellData.bookId)) {
    _cellData = cellData;
    [self.musBgImg.layer removeAllAnimations];
    _basicAnimation = nil;

    [self.player stop];
    
    [self.musBgImg sd_setImageWithURL:[NSURL URLWithString:_cellData.book_image] placeholderImage:[UIImage imageNamed:@"bookFind"]];
    self.navigationItem.title = [NSString stringWithFormat:@"学堂"];
    self.titleName.text = _cellData.book_name;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"aid"] = _cellData.bookId;
    params[@"uid"] = params[@"id"];   
        
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self.mgr POST:API_BOOKMP3 parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (200 == [responseObject[@"code"] integerValue]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                _musM = [[CHZBookMusModel alloc] initWithDict:responseObject[@"data"]];
                
                NSURL *url = [NSURL URLWithString:_musM.mp3_content];
                NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                [request setHTTPMethod: @"POST"];
                [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.readLB.text = _musM.read_counts;
                    self.timeLB.text = _musM.add_time;
                    self.sharedLB.text = _musM.comments;
                    
                    [self.webVIewLoad loadRequest:request];
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
        }

}


- (void)getCellData{
    
    if (_interviewData) {
        
        
        
    }
}

#pragma --mark 设计音乐播放

+(instancetype)shareBookMusViewController{
    static CHZBookMusViewController *listenVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        listenVC = [[CHZBookMusViewController alloc] init];
    });
    return listenVC;
}

//图片旋转
//懒加载
- (CABasicAnimation *)basicAnimation {
    if (_basicAnimation == nil) {
        self.basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //旋转一圈时长
        self.basicAnimation.duration = 30;
        //开始动画的起始位置
        self.basicAnimation.fromValue = [NSNumber numberWithInt:0];
        //M_PI是180度
        self.basicAnimation.toValue = [NSNumber numberWithInt:M_PI*2];
        //动画重复次数
        [self.basicAnimation setRepeatCount:NSIntegerMax];
        //播放完毕之后是否逆向回到原来位置
        [self.basicAnimation setAutoreverses:NO];
        //是否叠加（追加）动画效果
        [self.basicAnimation setCumulative:YES];
        //停止动画，速度设置为0
        self.musBgImg.layer.speed = 1;
        
        [self.musBgImg.layer addAnimation:self.basicAnimation forKey:@"basicAnimation"];
        
    }
    return _basicAnimation;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startPlay:(UIButton *)sender {
    if (self.player.state == STKAudioPlayerStatePaused) {
        
        //        //NSLog(@"暂停");
        [sender setBackgroundImage:[UIImage imageNamed:@"pause_96"] forState:UIControlStateNormal];
        [self.player resume];//继续
        //开始旋转
        //得到view当前动画时间偏移量
        CFTimeInterval stopTime = [self.musBgImg.layer timeOffset];
        //初始化开始时间
        self.musBgImg.layer.beginTime = 0;
        //初始化时间偏移量
        self.musBgImg.layer.timeOffset = 0;
        //设置动画速度
        self.musBgImg.layer.speed = 1;
        //计算时间差
        CFTimeInterval tempTime = [self.musBgImg.layer convertTime:CACurrentMediaTime() fromLayer:nil] - stopTime;
        //重新设置动画开始时间
        self.musBgImg.layer.beginTime = tempTime;
        
    }else if (self.player.state == STKAudioPlayerStatePlaying) {
        
        
        [sender setBackgroundImage:[UIImage imageNamed:@"play_96"] forState:UIControlStateNormal];
        [self.player pause];
        CFTimeInterval stopTime = [self.musBgImg.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        //停止动画，速度设置为0
        self.musBgImg.layer.speed = 0;
        //设置时间偏移量
        self.musBgImg.layer.timeOffset = stopTime;
        
    }else{
        
        HZLog(@"%d", self.player.state);
        [self.player play:_musM.mp3];
        [sender setBackgroundImage:[UIImage imageNamed:@"pause_96"] forState:UIControlStateNormal];
        [self.musBgImg.layer removeAllAnimations];//移除动画
        self.basicAnimation = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(track) userInfo:nil repeats:YES];
        
    }
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    if (state == STKAudioPlayerStateStopped) {
        [self.player stop];
        [self.musBgImg.layer removeAllAnimations];//移除动画
        self.basicAnimation = nil;
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"play_96"] forState:UIControlStateNormal];
    }
    if (state == STKAudioPlayerStatePlaying) {
        [self basicAnimation];
        
    }
}


// 通知事件
- (void)notificaitonAction:(NSNotification *)notification
{
    NSInteger type = [notification.object integerValue];
    
    switch (type) {
        case  UIEventSubtypeRemoteControlPlay: // 播放
            [_player resume];
            [self.startBtn setBackgroundImage:[UIImage imageNamed:@"pause_96"] forState:UIControlStateNormal];
            break;
        case UIEventSubtypeRemoteControlPause: // 暂停
            [_player pause];
            [self.startBtn setBackgroundImage:[UIImage imageNamed:@"play_96"] forState:UIControlStateNormal];
            break;
        case UIEventSubtypeRemoteControlNextTrack: // 下一首
            [self go15s:nil];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack: // 上一首
            [self back15s:nil];
            break;
        default:
            break;
    }
}

//处理中断事件
-(void)handleInterreption:(NSNotification *)sender
{
    if(self.player.state == STKAudioPlayerStatePlaying)
    {
        [_player pause];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"play_96"] forState:UIControlStateNormal];

    }else if(self.player.state == STKAudioPlayerStatePaused){
        [_player resume];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"pause_96"] forState:UIControlStateNormal];

    }else{
        [_player pause];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"play_96"] forState:UIControlStateNormal];
    }
    
    
}






-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    HZLog(@"完成缓冲");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    HZLog(@"完成播放");
    [self.player stop];
    [self.musBgImg.layer removeAllAnimations];//移除动画
    self.basicAnimation = nil;
    
    
}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId
{
    HZLog(@"开始播放");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    
    HZLog(@"离开");
}


-(void)track
{
    
    self.progressSlider.maximumValue = self.player.duration;//音乐总共时长
    self.progressSlider.value = self.player.progress;//当前进度
    
    //当前时长进度progress
    NSInteger proMin = (NSInteger)self.player.progress / 60;//当前秒
    NSInteger proSec = (NSInteger)self.player.progress % 60;//当前分钟
    
    //duration 总时长
    self.durMin = (NSInteger)self.player.duration / 60;//总秒
    self.durSec = (NSInteger)self.player.duration % 60;//总分钟
    
    self.startTime.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)proMin, (long)proSec];
    self.endTimeLable.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)self.durMin,(long)self.durSec];
    //    //NSLog(@"proMin = %ld proSec = %ld",proMin, proSec);
    //    if (proMin == self.durMin - 1 && proSec == self.durSec && self.durSec > 0) {
    //        [self nextButtonAction];
    //    }
    
    
}

- (IBAction)back15s:(id)sender {
    [self.musSlider setValue:self.musSlider.value - 15 animated:YES];
    [self.player seekToTime:self.musSlider.value];
}
- (IBAction)go15s:(id)sender {
    
    [self.musSlider setValue:self.musSlider.value + 15 animated:YES];
    [self.player seekToTime:self.musSlider.value];
    [CHZUserDefaults setObject:@"" forKey:@"token"];
}
- (IBAction)slideAnyWhere:(UISlider *)sender {
    if (self.player) {
        
        [self.player seekToTime:sender.value];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.player.state == STKAudioPlayerStatePlaying) {
        [self.musBgImg.layer removeAllAnimations];//移除动画
        self.basicAnimation = nil;
        [self basicAnimation];//开始动画
        
    }
    if (self.player.state == STKAudioPlayerStatePaused) {
        
        self.basicAnimation = nil;
        
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(self.player.state == STKAudioPlayerStatePlaying)
    {
        [CHZGlobalInstance shareInstance].isPlaying = YES;
        
    }else{
        [CHZGlobalInstance shareInstance].isPlaying = NO;
    }
    
    
    
//    [self.player stop];
}
- (IBAction)backView:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commentViewPush:(id)sender {
    if (_cellData) {
        CHZCommentsListTableViewController *comVC = [[CHZCommentsListTableViewController alloc] initWithStyle:UITableViewStylePlain aid:_musM.musId count:_musM.comments type:2];
        [self.navigationController pushViewController:comVC animated:YES];
    }else if(_interviewData){
        CHZCommentsListTableViewController *comVC = [[CHZCommentsListTableViewController alloc] initWithStyle:UITableViewStylePlain aid:_musM.musId count:_musM.comments type:3];
        [self.navigationController pushViewController:comVC animated:YES];
    }else{
        
    }

}

- (IBAction)commentBtnClick:(id)sender {
    [self showEditView];
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


@end
