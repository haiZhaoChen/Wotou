//
//  AppDelegate.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/1.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "AppDelegate.h"
#import "CHZMainTabBarViewController.h"
#import "CHZLoginViewController.h"
#import "CHZUserInfoModel.h"
#import "CHZGlobalInstance.h"
//微信SDK头文件
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "AppDelegate+XHLaunchAd.h"
#import "CHZUserVIPStateViewController.h"
#import "CHZPayViewController.h"

#define CHZAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic,strong)AFHTTPSessionManager *mgr;

@end

@implementation AppDelegate

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        // 1.创建请求管理对象
        _mgr = [AFHTTPSessionManager manager];
        
        // 说明服务器返回的JSON数据
        _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _mgr;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = CHZGlobalBg;
//    [self getToken];
    NSString *userId = [CHZUserDefaults objectForKey:@"userId"];
    NSString *token = [CHZUserDefaults objectForKey:@"token"];

    
    [self setupXHLaunchAd];
    [self setSharedSDK];
    
    [WXApi registerApp:WECHATAPI_PAY withDescription:@"窝头学堂"];
    
    if (userId&&token) {
        self.window.rootViewController = [[CHZMainTabBarViewController alloc] init];
        [self getUserInfo];
        
    }else{
        
        self.window.rootViewController = [[CHZLoginViewController alloc] init];

    }
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    [self.window makeKeyAndVisible];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [NSThread sleepForTimeInterval:0.8];//设置启动页面时间
    return YES;
}


- (void)showAdDetail:(NSNotification *)noti
{
    NSLog(@"detail parameters:%@", noti.object);
}

- (void)setSharedSDK{
    [ShareSDK registerApp:WECHATAPI
     
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeWechatFav)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
            default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxdd059f98e09921e2"
                                       appSecret:@"56169211372af11a2a13a2a03afdf7e1"];
                 break;
             default:
                 break;
         }
     }];
    
}






//获取用户数据
- (void)getUserInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    
    [self.mgr POST:API_USERINFO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"调用个人信息接口成功");
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != nil && responseObject[@"data"] !=[NSNull null]) {
                CHZUserInfoModel *userInfo = [[CHZUserInfoModel alloc] initWithDict:responseObject[@"data"]];
                [NSKeyedArchiver archiveRootObject:userInfo toFile:CHZAccountFile];
            }
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            
            CHZLoginViewController *barVC = [[CHZLoginViewController alloc] init];
            [self.window.rootViewController presentViewController:barVC animated:YES completion:^{
                
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error);
    }];
}


- (void)getToken{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 说明服务器返回的JSON数据
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"测试用户3";
    params[@"password"] = @"123456";
    
    
    [mgr POST:API_LOGIN parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"%@",responseObject);
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"id"] != [NSNull null] && responseObject[@"token"] != [NSNull null]) {
                NSString *idStr = responseObject[@"id"];
                NSString *token = responseObject[@"token"];
                [CHZUserDefaults setObject:idStr forKey:@"userId"];
                [CHZUserDefaults setObject:token forKey:@"token"];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@===%@",error.localizedDescription,error.description);
    }];
    
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //开启后台处理多媒体事件
    
    // 接受远程控制
    [self becomeFirstResponder];
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
//    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
//    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
}
//实现一下backgroundPlayerID:这个方法:
+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}





- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // 取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                HZLog(@"支付成功");
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                //注册支付
                if ([CHZGlobalInstance shareInstance].gotoWitchView == 111) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].keyWindow.rootViewController = [[CHZLoginViewController alloc] init];
                    });
                    //续费页面
                }else if ([CHZGlobalInstance shareInstance].gotoWitchView == 222){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getMoreUserInfo];
                        
                    });
                    //过期跳出
                } else if ([CHZGlobalInstance shareInstance].gotoWitchView == 333){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[CHZPayViewController shareInstance] dismissViewControllerAnimated:YES completion:^{
                            [self getMoreUserInfo];
                        }];
                    });
                    //未支付
                }else if([CHZGlobalInstance shareInstance].gotoWitchView == 666){
                    [[CHZPayViewController shareInstance] dismissViewControllerAnimated:YES completion:^{
                        self.window.rootViewController = [[CHZMainTabBarViewController alloc] init];
                        [self getUserInfo];
                    }];
                    
                }
                
                
                break;
            default:
                HZLog(@"支付失败，retcode=%d",resp.errCode);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"支付失败"];
                });
               
                
                break;
        }
    }
}


- (void)getMoreUserInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [CHZUserDefaults objectForKey:@"userId"];
    params[@"token"] = [CHZUserDefaults objectForKey:@"token"];
    
    params[@"uid"] = [CHZUserDefaults objectForKey:@"userId"];
    
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 说明服务器返回的JSON数据
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr POST:API_USERINFO parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HZLog(@"调用个人信息接口成功");
        if (200 == [responseObject[@"code"] integerValue]) {
            if (responseObject[@"data"] != nil && responseObject[@"data"] !=[NSNull null]) {
                CHZUserInfoModel *userInfo = [[CHZUserInfoModel alloc] initWithDict:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CHZUserVIPStateViewController shareInstance].endTimeLB.text = userInfo.end_time;
                    [[CHZUserVIPStateViewController shareInstance] getUserRight];
                });
                [NSKeyedArchiver archiveRootObject:userInfo toFile:CHZAccountFile];
                
            }
        }else if (704 == [responseObject[@"code"] integerValue]){
            //token过期
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HZLog(@"%@",error);
    }];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
