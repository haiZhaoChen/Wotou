//
//  CHZGlobalInstance.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZGlobalInstance : NSObject

+ (CHZGlobalInstance *)shareInstance;

@property (nonatomic, assign)BOOL isPlaying;

@property (nonatomic, assign)NSUInteger gotoWitchView;

@end
