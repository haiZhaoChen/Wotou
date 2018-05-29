//
//  CHZADImgModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZADImgModel : NSObject<NSCoding>

/*
 第一张广告图：ad_img1
 第二张广告图：ad_img2
 第三张广告图：ad_img3

 */

@property (nonatomic, copy)NSString *ad_img1;
@property (nonatomic, copy)NSString *ad_img2;
@property (nonatomic, copy)NSString *ad_img3;

+ (instancetype)ADImgModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
