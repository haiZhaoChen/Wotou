//
//  Util.m
//  TuLingBao_oc
//
//  Created by 刘欣 on 15/5/20.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import "Util.h"
#import "NSString+MD5Util.h"

#import <CommonCrypto/CommonDigest.h>
#include <objc/runtime.h>

#define IMAGE_NAME @"sharesdk_img"
#define IMAGE_EXT @"jpg"

#define CONTENT NSLocalizedString(@"TEXT_SHARE_CONTENT", @"ShareSDK不仅集成简单、支持如QQ好友、微信、新浪微博、腾讯微博等所有社交平台，而且还有强大的统计分析管理后台，实时了解用户、信息流、回流率、传播效应等数据，详情见官网http://sharesdk.cn @ShareSDK")
#define SHARE_URL @"http://www.mob.com"

@implementation Util




+ (NSString *)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *)md5Hash:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}
#pragma mark Encode Chinese to ISO8859-1 in URL
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr{
    
    CFStringRef nonAlphaNumValidChars = CFSTR("");
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8));
    NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8)) ;
    return newStr;
}


//时间戳
+(NSString*) timeStamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSLog(@"%@,%@",dat,[NSDate date]);
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeStampStr = [NSString stringWithFormat:@"%.0f", a];
    NSLog(@"时间戳：%@",timeStampStr);
    return timeStampStr;
}

//时间戳
+(NSString*) timeStamp:(NSString*)date{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dat = [dateFormatter dateFromString:date];
    NSLog(@"%@,%@",dat,[NSDate date]);
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeStampStr = [NSString stringWithFormat:@"%.0f", a];
    NSLog(@"时间戳：%@",timeStampStr);
    return timeStampStr;
}

//时间戳转换成日期
+(NSDate*) timeStampToDate:(NSString*)tempStamp{
    NSTimeInterval time=[tempStamp doubleValue]/1000;
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    return detaildate;
}

+(NSString*) createReqString:(NSArray*)reqArray AndNeedMd5:(BOOL)isNeed AndMd5Key:(NSString*)md5Key{
    
    NSArray* sortReqArray = [reqArray sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"排序后的数组：%@",sortReqArray);
    
    NSString* reqStr = @"";
    for (int i = 0; i < [sortReqArray count]; i++) {
        NSString* str = [sortReqArray objectAtIndex:i];
        reqStr = [reqStr stringByAppendingString:str];
        if (i < [sortReqArray count]-1) {
            reqStr = [reqStr stringByAppendingString:@"&"];
        }
    }
    NSLog(@"加密前字符串：%@",reqStr);
    
    if (isNeed) {
        NSString* sign = [reqStr stringByAppendingString:md5Key].md5;
        reqStr = [reqStr stringByAppendingFormat:@"&sign=%@",sign];
        NSLog(@"发送前数据：%@",reqStr);
    }
    
    return reqStr;
}

//截取手机号的后六位
-(NSString *)handleStringWithString:(NSString *)str{
    
    NSMutableString * muStr = [NSMutableString stringWithString:str];
    NSRange range1 = NSMakeRange(5, 6);
    NSString *resultStr = [muStr substringWithRange:range1];
    return resultStr;
}

- (void)noneUIShareButtonAction
{
   /* NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:NSLocalizedString(@"TEXT_HELLO_QZONE", @"Hello QQ空间")
                                        url:INHERIT_VALUE
                                       site:nil
                                    fromUrl:nil
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:INHERIT_VALUE
                                    playUrl:nil
                                       nswb:nil];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:NSLocalizedString(@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
                                             url:INHERIT_VALUE
                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:INHERIT_VALUE
                                            title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
                                              url:@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D"
                                       thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                            image:INHERIT_VALUE
                                     musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:INHERIT_VALUE
                                title:@"Hello QQ!"
                                  url:INHERIT_VALUE
                                image:INHERIT_VALUE];
    
    //定制短信信息
    //    [publishContent addSMSUnitWithContent:@"Hello SMS"];
    [publishContent addSMSUnitWithContent:@"ShareSDK github download address https://github.com/ShareSDKPlatform/ShareSDK-for-iOS"
                                  subject:nil
                              attachments:@[[ShareSDKCoreService attachmentWithUrl:@"http://f.hiphotos.bdimg.com/album/w%3D2048/sign=df8f1fe50dd79123e0e09374990c5882/cf1b9d16fdfaaf51e6d1ce528d5494eef01f7a28.jpg"]]
                                       to:@[@"15011991178"]];
    
    //结束定制信息
    ////////////////////////
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          [ShareSDK shareContent:publishContent
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:authOptions
                                                                                   statusBarTips:YES
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                              
                                                                                              if (state == SSPublishContentStateSuccess)
                                                                                              {
                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                              }
                                                                                              else if (state == SSPublishContentStateFail)
                                                                                              {
                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    
    //自定义腾讯微博分享菜单项
    id<ISSShareActionSheetItem> tencentItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                                                 icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                                         clickHandler:^{
                                                                             [ShareSDK shareContent:publishContent
                                                                                               type:ShareTypeTencentWeibo
                                                                                        authOptions:authOptions
                                                                                      statusBarTips:YES
                                                                                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                 
                                                                                                 if (state == SSPublishContentStateSuccess)
                                                                                                 {
                                                                                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                                 }
                                                                                                 else if (state == SSPublishContentStateFail)
                                                                                                 {
                                                                                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                                 }
                                                                                             }];
                                                                         }];
    
    //自定义QQ空间分享菜单项
    id<ISSShareActionSheetItem> qzoneItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]
                                                                               icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]
                                                                       clickHandler:^{
                                                                           [ShareSDK shareContent:publishContent
                                                                                             type:ShareTypeQQSpace
                                                                                      authOptions:authOptions
                                                                                    statusBarTips:YES
                                                                                           result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                               
                                                                                               if (state == SSPublishContentStateSuccess)
                                                                                               {
                                                                                                   NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                               }
                                                                                               else if (state == SSPublishContentStateFail)
                                                                                               {
                                                                                                   NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                               }
                                                                                           }];
                                                                       }];
    
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          sinaItem,
                          tencentItem,
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          qzoneItem,
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          SHARE_TYPE_NUMBER(ShareTypeAirPrint),
                          SHARE_TYPE_NUMBER(ShareTypeCopy),
                          //                          shItem,
                          //                          wyItem,
                          nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:_appDelegate.viewDelegate
                                                      friendsViewDelegate:_appDelegate.viewDelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                            }];*/
}

+ (UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[345789]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
//    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSString *pattern = @"^(www.|[a-zA-Z].)[a-zA-Z0-9\-\.]+\.(com|cn|edu|gov|mil|net|org|biz|info|name|museum|us|ca|uk)(:[0-9]+)*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}
#pragma makr - 检测是否为邮箱地址
+ (BOOL)validateEmail:(NSString *)emailString
{
    NSString *regex = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";
    //    NSString *regex = @"^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if(![pred evaluateWithObject:emailString]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma 严格身份证号验证
+(BOOL)verifyIDCardNumber:(NSString*)value
{
    value=[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([value length]!=18){
        return NO;
    }
    NSString*mmdd=@"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString*leapMmdd=@"0229";
    NSString*year=@"(19|20)[0-9]{2}";
    NSString*leapYear=@"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString*yearMmdd=[NSString stringWithFormat:@"%@%@",year,mmdd];
    NSString*leapyearMmdd=[NSString stringWithFormat:@"%@%@",leapYear,leapMmdd];
    NSString*yyyyMmdd=[NSString stringWithFormat:@"((%@)|(%@)|(%@))",yearMmdd,leapyearMmdd,@"20000229"];
    NSString*area=@"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString*regex=[NSString stringWithFormat:@"%@%@%@",area,yyyyMmdd,@"[0-9]{3}[0-9Xx]"];
    
    NSPredicate*regexTest=[NSPredicate predicateWithFormat:@"SELFMATCHES%@",regex];
    if(![regexTest evaluateWithObject:value]){
        return NO;
        }
    int summary=([value substringWithRange:NSMakeRange(0,1)].intValue+[value substringWithRange:NSMakeRange(10,1)].intValue)*7
    +([value substringWithRange:NSMakeRange(1,1)].intValue+[value substringWithRange:NSMakeRange(11,1)].intValue)*9
    +([value substringWithRange:NSMakeRange(2,1)].intValue+[value substringWithRange:NSMakeRange(12,1)].intValue)*10
    +([value substringWithRange:NSMakeRange(3,1)].intValue+[value substringWithRange:NSMakeRange(13,1)].intValue)*5
    +([value substringWithRange:NSMakeRange(4,1)].intValue+[value substringWithRange:NSMakeRange(14,1)].intValue)*8
    +([value substringWithRange:NSMakeRange(5,1)].intValue+[value substringWithRange:NSMakeRange(15,1)].intValue)*4
    +([value substringWithRange:NSMakeRange(6,1)].intValue+[value substringWithRange:NSMakeRange(16,1)].intValue)*2
    +[value substringWithRange:NSMakeRange(7,1)].intValue*1+[value substringWithRange:NSMakeRange(8,1)].intValue*6
    +[value substringWithRange:NSMakeRange(9,1)].intValue*3;
    NSInteger remainder=summary%11;
    NSString*checkBit=@"";
    NSString*checkString=@"10X98765432";
    checkBit=[checkString substringWithRange:NSMakeRange(remainder,1)];//判断校验位
    return[checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)]uppercaseString]];
    }

@end
