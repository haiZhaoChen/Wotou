//
//  CHZArticleReadViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZArticleReadViewController.h"
#import "CHZBookArticle.h"
#import "CHZBookArticleModel.h"
#import "UIBarButtonItem+CHZ.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CHZCardModel.h"
#import "OSCPopInputView.h"
#import "CHZFootTableViewCell.h"
#import "CHZCommentsListTableViewController.h"

@interface CHZArticleReadViewController ()<UIWebViewDelegate,OSCPopInputViewDelegate>
@property (nonatomic,strong)AFHTTPSessionManager *mgr;
//评论
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) OSCPopInputView *inputView;
//软键盘size
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

//数据
@property (nonatomic,strong)CHZBookArticle *bookArticle;
@property (nonatomic,strong)CHZBookArticleModel *textM;
@property (nonatomic,strong)CHZCardModel *card;

//标头
@property (weak, nonatomic) IBOutlet UILabel *titileName;
@property (weak, nonatomic) IBOutlet UILabel *readNumLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *commentLB;

//web
@property (weak, nonatomic) IBOutlet UIWebView *webLoadView;
@property (nonatomic,strong)CHZFootTableViewCell *shareBar;
//@property (nonatomic,strong)UIView *failView;

//是否可以分享
@property (nonatomic, assign)BOOL isCanShare;
@property (nonatomic, copy)NSString *isShareSrt;

//10秒内不能发评论
@property (nonatomic,assign)BOOL isCanPushComents;

@end

@implementation CHZArticleReadViewController



- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}


- (IBAction)commentBtnClick:(UIButton *)sender {
    [self showEditView];
}
- (IBAction)commentList {
    CHZCommentsListTableViewController *comVC = [[CHZCommentsListTableViewController alloc] initWithStyle:UITableViewStylePlain aid:_bookArticle.bookArtId count:_bookArticle.comments type:1];
    [self.navigationController pushViewController:comVC animated:YES];
}
- (IBAction)returnBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)initWithCellData:(CHZBookArticle *)article{
    if (self = [super init]) {
        _bookArticle = article;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CHZGlobalBg;
    self.navigationItem.title = @"美文详情";
    self.webLoadView.delegate = self;
    
    /* 设置导航   */
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"rightShared" higlightedImage:@"rightShared_on" target:self action:@selector(sharedBtnClick)];
    
    //加载尾部视图
    _shareBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHZFootTableViewCell class]) owner:self options:nil] firstObject];

    // Do any additional setup after loading the view from its nib.
    self.commentBtn.layer.masksToBounds = YES;
    self.commentBtn.layer.cornerRadius = 5.0;
    //self.commenBtn.layer.borderColor = [UIColor blackColor];
    
    self.commentBtn.layer.borderWidth = 1.0f;
    
    self.commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [self setupArticleData];
    [self checkIsCanShare];
    
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

- (void)setupArticleData{
    
    if (_bookArticle) {
        self.titileName.text = _bookArticle.title;
        self.readNumLB.text = _bookArticle.read_counts;
        
        self.commentLB.text = _bookArticle.share_counts;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"aid"] = _bookArticle.bookArtId;
        params[@"uid"] = params[@"id"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        [self.mgr POST:API_SCHOOLARTINFO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                if (responseObject[@"card"] && responseObject[@"card"] != [NSNull null]) {
                    _card = [[CHZCardModel alloc] initWithDict:responseObject[@"card"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _shareBar.nameLB.text = _card.nickname;
                        _shareBar.telLB.text = _card.tel;
                        
                        [_shareBar.iconImg sd_setImageWithURL:[NSURL URLWithString:_card.head_pic] placeholderImage:[UIImage imageNamed:@"qr_code"]];
                        [_shareBar.qrcodeImg sd_setImageWithURL:[NSURL URLWithString:_card.qr_code] placeholderImage:[UIImage imageNamed:@"perImg"]];
                    });
                    
                    
                    
                }
                if (responseObject[@"data"] && responseObject[@"data"] != [NSNull null]) {
                    _textM = [[CHZBookArticleModel alloc] initWithDict:responseObject[@"data"]];
                    
                    self.timeLB.text = _textM.add_time;
                    //                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[detail.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                    NSURL *url = [NSURL URLWithString:_textM.content];
                    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                    [request setHTTPMethod: @"POST"];
                    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.webLoadView loadRequest:request];
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
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            
            HZLog(@"%@",error);
        }];

        
        
    }
}

//web代理
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    HZLog(@"%@",NSStringFromCGSize(webView.scrollView.contentSize));
    _shareBar.frame = CGRectMake(0, webView.scrollView.contentSize.height, kScreenWidth, 220);
    
    UIEdgeInsets insetNew = webView.scrollView.contentInset;
    insetNew.bottom = 220;
    webView.scrollView.contentInset = insetNew;
    
    [webView.scrollView addSubview:self.shareBar];
    //    webView.scrollView.subviews[0].frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1579);
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code == NSURLErrorCancelled) {
        
        return;
    }
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"页面加载失败"];
//    [webView addSubview:self.failView];
    
}


//用户是否能够分享文章
- (void)checkIsCanShare{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"uid"] = params[@"id"];
    [self.mgr POST:API_BOOKISCANSHARE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (200 == [responseObject[@"code"] integerValue]) {
            self.isCanShare = YES;
        }else if (400 == [responseObject[@"code"] integerValue]){
            _isShareSrt = responseObject[@"message"];
        }else{
            _isShareSrt = @"分享失败\n请重新进入页面再试一次";
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isShareSrt = @"分享失败\n请重新进入页面再试一次";
    }];
}
#pragma --mark 分享
- (void)sharedBtnClick{
    HZLog(@"转发");
    if (self.isCanShare) {
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"wechatShare"]];
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSString *textCon;
            if (_bookArticle.bookArtDescription.length) {
                textCon = _bookArticle.bookArtDescription;
            }else{
                textCon = @"好文章尽在窝头学堂";
            }
            [shareParams SSDKSetupShareParamsByText:textCon
                                             images:imageArray
                                                url:[NSURL URLWithString:[NSString stringWithFormat:API_BOOKSHAREURL,_bookArticle.bookArtId,[CHZUserDefaults objectForKey:@"userId"]]]
                                              title:_bookArticle.title
                                               type:SSDKContentTypeAuto];
            //有的平台要客户端分享需要加此方法，例如微博
            [shareParams SSDKEnableUseClientShare];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   [self pushShareInfoToServer];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];}
    }else{
        [SVProgressHUD showErrorWithStatus:_isShareSrt];
    }

}
//通知服务端分享结果
- (void)pushShareInfoToServer{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] = params[@"id"];
    params[@"aid"] = _bookArticle.bookArtId;
    [self.mgr POST:API_BOOKDOSHARE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"回调");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error);
    }];
    //更新是否能够分享
    [self checkIsCanShare];
    
}

#pragma --mark评论事件
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
        //        _inputView.popInputViewType = OSCPopInputViewType_At | OSCPopInputViewType_Forwarding;
        //        _inputView.draftKeyID = [NSString stringWithFormat:@"%ld",self.commentId];
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
    
    if (_bookArticle) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"bid"] = _bookArticle.bookArtId;
        params[@"uid"] = params[@"id"];
        params[@"content"] = textView.text;
        [SVProgressHUD show];
        [self.mgr POST:API_BOOKARTICLECOMMENTS parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
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
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"回复失败，稍后再试"];
        }];
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
