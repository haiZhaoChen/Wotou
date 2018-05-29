//
//  CHZBookVideo.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/25.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZBookVideo : NSObject

/*
 "book_image" = "/public/uploads/images/20170125/thumb_87287b30805d821389eda45ee9a787b8.png";
 "book_name" = "\U6d4b\U8bd5";
 id = 4;
*/


@property (nonatomic, copy)NSString *bookId;
@property (nonatomic, copy)NSString *book_image;
@property (nonatomic, copy)NSString *book_name;


+ (instancetype)bookVideoWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
