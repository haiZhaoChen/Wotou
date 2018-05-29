//
//  CHZCommentsTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/14.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZCommentFrames;
@class CHZCommentModel;


@interface CHZCommentsTableViewCell : UITableViewCell

@property (nonatomic, strong)CHZCommentFrames *statusFrame;
/** */
@property (nonatomic,assign)NSUInteger type;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
