//
//  CHZSharedTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHZSharedTableViewCellDelegate <NSObject>

- (void)titleBtnClickWithIndex:(NSInteger)index;

@end

@interface CHZSharedTableViewCell : UITableViewCell

@property (nonatomic, weak)id<CHZSharedTableViewCellDelegate> delegate;


- (void)scrollToCenterWithIndex:(NSUInteger)index;

@end
