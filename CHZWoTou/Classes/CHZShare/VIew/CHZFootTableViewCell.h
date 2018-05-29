//
//  CHZFootTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/13.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FootTableViewCellDelegate <NSObject>

- (void)gotoMyWeb;

@end

@interface CHZFootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *telLB;

/**
 *  dele
 */
@property (nonatomic, weak)id<FootTableViewCellDelegate> delegate;

@end
