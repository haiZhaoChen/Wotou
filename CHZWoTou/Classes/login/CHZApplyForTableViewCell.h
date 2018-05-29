//
//  CHZApplyForTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ApplyForCell @"ApplyForCell"

@protocol ApplyForTableViewCellDelegate <NSObject>

- (void)applyForBtnClick;
- (void)xieyiWebClick;

@end

@interface CHZApplyForTableViewCell : UITableViewCell

/**
 *  delegate
 */
@property (nonatomic, weak)id<ApplyForTableViewCellDelegate> delegate;

@end
