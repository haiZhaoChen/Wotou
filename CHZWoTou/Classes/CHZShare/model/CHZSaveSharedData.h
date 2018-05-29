//
//  CHZSaveSharedData.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/22.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHZArticleData;

@interface CHZSaveSharedData : NSObject

@property (nonatomic, strong)NSArray<CHZArticleData *> * articleDatas;
@property (nonatomic, copy)NSString *nameId;

+ (instancetype)saveSharedDataWith:(NSArray<CHZArticleData *> *)articleDataList
                             nameId:(NSString *)nameId;

@end
