//
//  CHZDetailModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZDetailModel : NSObject
/*
 {
 card =     {
 "head_pic" = "20170208/794d6b7eacc206af4124b2dcacbc6973.jpg";
 id = 3;
 nickname = Cheney;
 "qr_code" = "20170208/1d6d5b7118817b002f260538a2a73166.jpg";
 tel = 546565668;
 uid = 3;
 website = "www.ceshi.com";
 };
 cname = "管理";
 code = 200;
 data =     {
 "add_time" = "2016-12-28 09:04:57";
 agent = 0;
 auther = admin;
 column = 4;
 content = "<p style=\"line-height: 1.5em; text-align: center; text-indent: 0em;\"><strong>01</strong></p><p><br/></p><p style=\"line-height: 1.5em; text-indent: 2em;\">妻子想让老公早回家，于是规定：晚于11点回家就锁门。第一周奏效，第二周老公又晚归，老婆按制度把门锁了，";
 description = "";
 id = 5473;
 "read_counts" = 1671;
 "share_counts" = 0;
 
 title = "老婆说: 你敢晚上不回来, 我就开着大门睡觉, 结果男人回来发现...";
 type = 1;
 //没写
 status = 1;
 keywords = "<null>";
 };
 message = "文章详情";
 }
 
 
 */

@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *agent;//代理人
@property (nonatomic, copy)NSString *auther;
@property (nonatomic, copy)NSString *column;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *kDescription;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *read_counts;
@property (nonatomic, copy)NSString *share_counts;
@property (nonatomic, copy)NSString *aId;
@property (nonatomic, copy)NSString *type;

+ (instancetype)detailModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
