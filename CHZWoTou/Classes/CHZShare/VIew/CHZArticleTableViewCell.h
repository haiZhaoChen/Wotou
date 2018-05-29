//
//  CHZArticleTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/21.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHZArticleData;

#define CHZSharedArticleCell @"sharedArticleCell"

@interface CHZArticleTableViewCell : UITableViewCell


@property (nonatomic, strong)CHZArticleData *artData;


@end
