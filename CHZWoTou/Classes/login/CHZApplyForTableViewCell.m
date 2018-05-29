//
//  CHZApplyForTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZApplyForTableViewCell.h"

@implementation CHZApplyForTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)applyForClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(applyForBtnClick)]) {
        [self.delegate applyForBtnClick];
    }
}
- (IBAction)xieyiWeb:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(xieyiWebClick)]) {
        [self.delegate xieyiWebClick];
    }
}

@end
