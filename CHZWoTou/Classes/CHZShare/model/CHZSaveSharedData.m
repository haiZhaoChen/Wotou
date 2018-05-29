//
//  CHZSaveSharedData.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/22.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZSaveSharedData.h"

@implementation CHZSaveSharedData

+ (instancetype)saveSharedDataWith:(NSArray<CHZArticleData *> *)articleDataList
                             nameId:(NSString *)nameId{
    CHZSaveSharedData *saveShared = [CHZSaveSharedData new];
    saveShared.articleDatas = articleDataList;
    saveShared.nameId = nameId;
    return saveShared;
}


@end
