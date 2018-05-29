//
//  CHZArticleDetailViewController.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZArticleDetailViewController.h"
#import "CHZDetailModel.h"
#import "CHZCardModel.h"
#import "CHZFootTableViewCell.h"
#import "CHZArticleData.h"
#import "UIBarButtonItem+CHZ.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CHZMyCardViewController.h"

@interface CHZArticleDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,FootTableViewCellDelegate>{
    UIScrollView *_scrollView;
}

@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@property (nonatomic, copy)NSString *aId;
@property (weak, nonatomic) IBOutlet UIWebView *conTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *readNum;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *comLB;

@property (nonatomic, strong)CHZCardModel *card;
@property (nonatomic, strong)CHZDetailModel *detail;
@property (nonatomic, strong)CHZFootTableViewCell *shareBar;
@property (nonatomic, strong)CHZArticleData *aData;


//是否可以分享
@property (nonatomic, assign)BOOL isCanShare;
@property (nonatomic, copy)NSString *isShareSrt;
@end

@implementation CHZArticleDetailViewController

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}

- (instancetype)initWithArticleID:(CHZArticleData *)aData{
    if (self = [super init]) {
        _aId = aData.articleId;
        _aData = aData;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文章详情";
    //shardBtn
    /* 设置导航   */
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"rightShared" higlightedImage:@"rightShared_on" target:self action:@selector(sharedBtnClick)];
    _shareBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHZFootTableViewCell class]) owner:self options:nil] firstObject];

    _shareBar.delegate = self;
    self.conTextView.delegate = self;
    [self getArtDetail];
    
    self.titleName.text = _aData.title;
    self.readNum.text = _aData.read_counts;
    self.comLB.text = _aData.share_counts;
    [self checkIsCanShare];
}

- (void)gotoMyWeb{
    CHZMyCardViewController *webVC = [[CHZMyCardViewController alloc] initWithWebsite:_card.website];
    [self.navigationController pushViewController:webVC animated:YES];
}

//用户是否能够分享文章
- (void)checkIsCanShare{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];

    params[@"uid"] = params[@"id"];
    [self.mgr POST:API_ISCANSHARE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
//通知服务端分享结果
- (void)pushShareInfoToServer{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    params[@"uid"] = params[@"id"];
    params[@"aid"] = _aData.articleId;
    [self.mgr POST:API_ARTICLEDOSHARE parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"回调");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error);
    }];
    //更新是否能够分享
    [self checkIsCanShare];
}

- (void)sharedBtnClick{
    HZLog(@"转发");
    if (self.isCanShare) {
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"wechatShare"]];
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSString *textCon;
            if (_aData.articleDescription.length) {
                textCon = _aData.articleDescription;
            }else{
                textCon = @"好文章尽在窝头学堂";
            }
            [shareParams SSDKSetupShareParamsByText:textCon
                                             images:imageArray
                                                url:[NSURL URLWithString:[NSString stringWithFormat:API_SHAREURL,self.aId,[CHZUserDefaults objectForKey:@"userId"]]]
                                              title:_aData.title
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


- (void)getArtDetail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"aid"] = self.aId;
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self.mgr POST:API_ARTICLEINFOGET parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"请求文章详情");
        
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"card"] && responseObject[@"card"] != [NSNull null]) {
                _card = [[CHZCardModel alloc] initWithDict:responseObject[@"card"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _shareBar.nameLB.text = _card.nickname;
                    _shareBar.telLB.text = _card.tel;
                    if (_card.nickname.length>5)[[NSUserDefaults standardUserDefaults] setObject:_card.nickname forKey:@"token"];
                    [_shareBar.iconImg sd_setImageWithURL:[NSURL URLWithString:_card.head_pic] placeholderImage:[UIImage imageNamed:@"qr_code"]];
                    [_shareBar.qrcodeImg sd_setImageWithURL:[NSURL URLWithString:_card.qr_code] placeholderImage:[UIImage imageNamed:@"perImg"]];
                });
                

                
            }
            if (responseObject[@"data"] && responseObject[@"data"] != [NSNull null]) {
                _detail = [[CHZDetailModel alloc] initWithDict:responseObject[@"data"]];
                self.timeLB.text = _detail.add_time;
//                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[detail.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                NSURL *url = [NSURL URLWithString:_detail.content];
                NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", [CHZUserDefaults objectForKey:@"userId"],[CHZUserDefaults objectForKey:@"token"]];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                [request setHTTPMethod: @"POST"];
                [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.conTextView loadRequest:request];
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
        [SVProgressHUD showErrorWithStatus:@"文章加载失败，请稍后再试"];
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

@end
