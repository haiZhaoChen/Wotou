//
//  CHZRegistModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/16.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZRegistModel : NSObject
@property (nonatomic, copy)NSString *payId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *payMoney;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
