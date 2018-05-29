//
//  CHZTuiGuangModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/10.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZTuiGuangModel.h"
#import "CHZTGInfoModel.h"
/*
 @property (nonatomic, copy)NSString *count;
 @property (nonatomic, copy)NSString *month_count;
 @property (nonatomic, copy)NSString *last_month_count;
 @property (nonatomic, copy)NSArray *infoArr;
 */

@implementation CHZTuiGuangModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.count = [NSString stringWithFormat:@"%@",dict[@"count"]];
        self.month_count = [NSString stringWithFormat:@"%@",dict[@"month_count"]];
        self.last_month_count = [NSString stringWithFormat:@"%@",dict[@"last_month_count"]];
        NSArray *arr = dict[@"data"];
        
        if (arr.count >0) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *d in arr) {
                CHZTGInfoModel *info = [[CHZTGInfoModel alloc] initWithDict:d];
                [tempArr addObject:info];
            }
            self.infoArr = tempArr;
        }
        
    }
    return self;
}

@end
