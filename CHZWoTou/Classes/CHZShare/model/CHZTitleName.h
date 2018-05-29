//
//  CHZTitleName.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/22.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZTitleName : NSObject

@property (nonatomic, copy)NSString *nameId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *pid;

+ (instancetype)titleNameWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
