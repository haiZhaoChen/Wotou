//
//  CHZimgBtnTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZimgBtnTableViewCell.h"

@implementation CHZimgBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)onSide {
    if ([self.delegate respondsToSelector:@selector(postImgBtnClickType:)]) {
        [self.delegate postImgBtnClickType:1];
    }
}
- (IBAction)backSide {
    if ([self.delegate respondsToSelector:@selector(postImgBtnClickType:)]) {
        [self.delegate postImgBtnClickType:2];
    }
}
- (IBAction)certificate {
    if ([self.delegate respondsToSelector:@selector(postImgBtnClickType:)]) {
        [self.delegate postImgBtnClickType:3];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
