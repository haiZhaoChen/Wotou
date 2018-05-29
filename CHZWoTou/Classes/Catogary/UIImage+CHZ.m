//
//  UIImage+CHZ.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/14.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "UIImage+CHZ.h"

thisDeviceClass currentDeviceClass() {
    
    CGFloat greaterPixelDimension = (CGFloat) fmaxf(((float)[[UIScreen mainScreen]bounds].size.height),
                                                    ((float)[[UIScreen mainScreen]bounds].size.width));
    
    switch ((NSInteger)greaterPixelDimension) {
        case 480:
            return (( [[UIScreen mainScreen] scale] > 1.0) ? thisDeviceClass_iPhoneRetina : thisDeviceClass_iPhone );
            break;
        case 568:
            return thisDeviceClass_iPhone5;
            break;
        case 667:
            return thisDeviceClass_iPhone6;
            break;
        case 736:
            return thisDeviceClass_iPhone6plus;
            break;
        case 1024:
            return (( [[UIScreen mainScreen] scale] > 1.0) ? thisDeviceClass_iPadRetina : thisDeviceClass_iPad );
            break;
        default:
            return thisDeviceClass_unknown;
            break;
    }
}


@implementation UIImage (CHZ)

+ (UIImage *)originalImageWithName:(NSString *)name
{
    return [[self imageWithName:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

+ (UIImage *)imageWithName:(NSString *)name
{

    NSString *newName = [name stringByAppendingString:@"_os7"];
    
    // 利用新的文件名加载图片
    UIImage *image = [self imageNamed:newName];
    // 不存在这张图片
    if (image == nil) {
        image = [self imageNamed:name];
    }
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name leftScale:0.5 topScale:0.5];
}


+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale
{
    UIImage *image = [self imageWithName:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftScale topCapHeight:image.size.height * topScale];
}

+ (instancetype )imageForDeviceWithName:(NSString *)fileName
{
    UIImage *result = nil;
    NSString *nameWithSuffix = [fileName stringByAppendingString:[UIImage magicSuffixForDevice]];
    
    result = [UIImage imageNamed:nameWithSuffix];
    if (!result) {
        result = [UIImage imageNamed:fileName];
    }
    return result;
}


+ (NSString *)magicSuffixForDevice
{
    switch (currentDeviceClass()) {
        case thisDeviceClass_iPhone:
            return @"";
            break;
        case thisDeviceClass_iPhoneRetina:
            return @"@2x";
            break;
        case thisDeviceClass_iPhone5:
            return @"-568h";
            break;
        case thisDeviceClass_iPhone6:
            return @"-667h"; //or some other arbitrary string..
            break;
        case thisDeviceClass_iPhone6plus:
            return @"-736h";
            break;
            
        case thisDeviceClass_iPad:
            return @"~ipad";
            break;
        case thisDeviceClass_iPadRetina:
            return @"~ipad@2x";
            break;
            
        case thisDeviceClass_unknown:
        default:
            return @"";
            break;
    }
}


//

#pragma mark-------根据imgView的宽高获得图片的比例

+ (UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    UIImage * image =[[UIImage alloc] init];
    
    UIImage * newImage =  [image getImageFromUrl:imgUrl imgViewWidth:width imgViewHeight:height];
    
    return newImage;
    
}


//对象方法

- (UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    //data 转image
    
    UIImage * image ;
    
    //根据网址将图片转化成image
    
    NSData * data = [NSData dataWithContentsOfURL:imgUrl];
    
    image =[UIImage imageWithData:data];
    
    //图片剪切
    
    UIImage * newImage = [self cutImage:image imgViewWidth:width imgViewHeight:height];
    
    return newImage;
    
}

//裁剪图片

- (UIImage *)cutImage:(UIImage*)image imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height

{
    
    //压缩图片
    
    CGSize newSize;
    
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (width / height)) {
        
        newSize.width = image.size.width;
        
        newSize.height = image.size.width * height /width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        
        newSize.height = image.size.height;
        
        newSize.width = image.size.height * width / height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    UIImage *reImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return reImg;
    
}


@end
