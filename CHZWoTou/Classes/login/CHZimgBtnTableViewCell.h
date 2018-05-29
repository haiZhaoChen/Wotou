//
//  CHZimgBtnTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ImgBtnCell @"ImgBtnCell"

@protocol ImgBtnTableViewCellDelegate <NSObject>

- (void)postImgBtnClickType:(NSUInteger)type;


@end
@interface CHZimgBtnTableViewCell : UITableViewCell

/**
 *  delegate
 */
@property (nonatomic, weak)id<ImgBtnTableViewCellDelegate> delegate;

@end
