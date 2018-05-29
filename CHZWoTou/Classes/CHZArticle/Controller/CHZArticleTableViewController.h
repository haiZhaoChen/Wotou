//
//  CHZArticleTableViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZBookArticle;
@protocol ArticleTableViewDelegate <NSObject>

- (void)articleReadPush:(CHZBookArticle *)cellData;

@end

@interface CHZArticleTableViewController : UITableViewController

@property (nonatomic, weak)id<ArticleTableViewDelegate> delegate;

@end
