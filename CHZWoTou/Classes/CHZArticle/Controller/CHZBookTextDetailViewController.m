//
//  CHZBookTextDetailViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/27.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookTextDetailViewController.h"
#import "CHZBookVideo.h"
#import "CHZinterviewModel.h"
#import "OSCPopInputView.h"
#import "CHZBookText.h"
#import "CHZCommentsListTableViewController.h"

@interface CHZBookTextDetailViewController ()<UIWebViewDelegate,OSCPopInputViewDelegate>
//评论
@property (weak, nonatomic) IBOutlet UIButton *commenBtn;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) OSCPopInputView *inputView;
//软键盘size
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

//头图
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *readLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *sharedLB;

@property (weak, nonatomic) IBOutlet UIWebView *webVIewLoad;

//数据
@property (nonatomic, strong)CHZBookText *textM;



@property (nonatomic, strong)CHZinterviewModel *interviewData;
@property (nonatomic, strong)CHZBookVideo *cellData;


@property (nonatomic,strong)AFHTTPSessionManager *mgr;
//10秒内不能发评论
@property (nonatomic,assign)BOOL isCanPushComents;
@end

@implementation CHZBookTextDetailViewController

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
    
    self.view.backgroundColor = CHZGlobalBg;
    // Do any additional setup after loading the view from its nib.
    self.commenBtn.layer.masksToBounds = YES;
    self.commenBtn.layer.cornerRadius = 5.0;
    //self.commenBtn.layer.borderColor = [UIColor blackColor];
    
    self.commenBtn.layer.borderWidth = 1.0f;
    
    self.commenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    self.webVIewLoad.delegate = self;
    [self getInterviewData];
    
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

- (void)dealloc{
    HZLog(@"删除监听");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getInterviewData{
    if (_cellData) {
        
        self.navigationItem.title = [NSString stringWithFormat:@"学堂"];
        self.titleName.text = _cellData.book_name;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"aid"] = _cellData.bookId;
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        [self.mgr POST:API_BOOKTEXTVIEW parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                
                if (responseObject[@"data"] != [NSNull null]) {
                    
                    _textM = [[CHZBookText alloc] initWithDict:responseObject[@"data"]];
                    
                    NSURL *url = [NSURL URLWithString:_textM.content];
                    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                    [request setHTTPMethod: @"POST"];
                    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.readLB.text = _textM.read_counts;
                        self.timeLB.text = _textM.add_time;
                        self.sharedLB.text = _textM.comments;
                        
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
        
    }else if(_interviewData){
        self.navigationItem.title = [NSString stringWithFormat:@"访谈"];
        self.titleName.text = _interviewData.title;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
        params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
        params[@"aid"] = _interviewData.interviewId;
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        [self.mgr POST:API_INTERVIEWTEXTVIEW parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (200 == [responseObject[@"code"] integerValue]) {
                
                if (responseObject[@"data"] != [NSNull null]) {
                    
                    _textM = [[CHZBookText alloc] initWithDict:responseObject[@"data"]];
                    
                    NSURL *url = [NSURL URLWithString:_textM.content];
                    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                    [request setHTTPMethod: @"POST"];
                    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.readLB.text = _textM.read_counts;
                        self.timeLB.text = _textM.add_time;
                        self.sharedLB.text = _textM.comments;
                        
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

        
        
    }else{
        
    }
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




- (IBAction)commentBtnClick:(id)sender {
    if (_cellData) {
        CHZCommentsListTableViewController *comVC = [[CHZCommentsListTableViewController alloc] initWithStyle:UITableViewStylePlain aid:_textM.textId count:_textM.comments type:2];
        [self.navigationController pushViewController:comVC animated:YES];
    }else if(_interviewData){
        CHZCommentsListTableViewController *comVC = [[CHZCommentsListTableViewController alloc] initWithStyle:UITableViewStylePlain aid:_textM.textId count:_textM.comments type:3];
        [self.navigationController pushViewController:comVC animated:YES];
    }else{
        
    }
    
}
- (IBAction)backViewClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)comentToArticle:(id)sender {
    
    [self showEditView];
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
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            [CHZUserDefaults setObject:self.nibName forKey:@"token"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isCanPushComents = NO;
            });
            
        }else{
            
            timeOut--;
        }
    });
    
    dispatch_resume(_timer);

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
