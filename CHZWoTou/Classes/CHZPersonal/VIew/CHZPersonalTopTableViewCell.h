//
//  CHZPersonalTopTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/31.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CHZPersonalTop @"CHZPersonalTop"

@protocol PersonalTopTableViewCellDelegate <NSObject>

- (void)tuiGuangPush;

@end

@interface CHZPersonalTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconimg;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *name;

/**
 *  代理
 */
@property (nonatomic, weak)id<PersonalTopTableViewCellDelegate> delegate;

@end
