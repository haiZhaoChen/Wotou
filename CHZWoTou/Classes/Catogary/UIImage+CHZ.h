//
//  UIImage+CHZ.h
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/14.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, thisDeviceClass) {
    
    thisDeviceClass_iPhone,
    thisDeviceClass_iPhoneRetina,
    thisDeviceClass_iPhone5,
    thisDeviceClass_iPhone6,
    thisDeviceClass_iPhone6plus,
    
    // we can add new devices when we become aware of them
    
    thisDeviceClass_iPad,
    thisDeviceClass_iPadRetina,
    
    
    thisDeviceClass_unknown
};

thisDeviceClass currentDeviceClass();

@interface UIImage (CHZ)
/**
 *  返回没有渲染的原始图片
 *
 *  @param name 文件名
 */
+ (UIImage *)originalImageWithName:(NSString *)name;

/**
 *  加载项目中的图片
 *
 *  @param name 文件名
 *
 *  @return 一个新的图片对象
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回能够自由拉伸不变形的图片
 *
 *  @param name 文件名
 *
 *  @return 能够自由拉伸不变形的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *   返回能够自由拉伸不变形的图片
 *
 *  @param name      文件名
 *  @param leftScale 左边需要保护的比例（0~1）
 */
+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;

/**
 *  适配图片
 */
+ (instancetype )imageForDeviceWithName:(NSString *)fileName;


+(UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height;


@end
