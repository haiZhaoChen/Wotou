//
//  CHZImgArticleTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/24.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZBookArticle;

#define ArticleTableViewCell @"CHZImgArticleTableViewCell"

@interface CHZImgArticleTableViewCell : UITableViewCell

@property (nonatomic, strong)CHZBookArticle *bookArticle;

- (void)setArticelData:(CHZBookArticle *)art;

@end
