//
//  CHZProjectModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/8.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 图片地址：xm_img1
 完整地址：/public/uploads/images/20161222/thumb_1b4e4b69ac3fd1c8996790ecce219fef.png
 项目标题：xm_title1
 {
 "xm_img1" = "/public/uploads/images/";
 "xm_img2" = "/public/uploads/images/";
 "xm_img3" = "/public/uploads/images/";
 "xm_img4" = "/public/uploads/images/";
 "xm_title1" = "<null>";
 "xm_title2" = "<null>";
 "xm_title3" = "<null>";
 "xm_title4" = "<null>";
 };

 */

@interface CHZProjectModel : NSObject<NSCoding>
@property (nonatomic, copy)NSString *xm_img1;
@property (nonatomic, copy)NSString *xm_title1;
@property (nonatomic, copy)NSString *xm_img2;
@property (nonatomic, copy)NSString *xm_title2;
@property (nonatomic, copy)NSString *xm_img3;
@property (nonatomic, copy)NSString *xm_title3;
@property (nonatomic, copy)NSString *xm_img4;
@property (nonatomic, copy)NSString *xm_title4;

+ (instancetype)projectWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
