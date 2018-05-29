//
//  CHZBookTitleTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHZBookTitleTableViewCellDelegate <NSObject>

- (void)titleBtnClickWithIndex:(NSInteger)index;

@end


@interface CHZBookTitleTableViewCell : UITableViewCell

@property(nonatomic, weak)id<CHZBookTitleTableViewCellDelegate> delegate;


- (void)scrollToCenterWithIndex:(NSUInteger)index;



@end
