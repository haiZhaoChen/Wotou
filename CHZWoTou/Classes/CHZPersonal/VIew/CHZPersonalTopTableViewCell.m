//
//  CHZPersonalTopTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/31.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZPersonalTopTableViewCell.h"

@implementation CHZPersonalTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    HZLog(@"%f,%f",self.height,self.width);
    
}
- (IBAction)tuiguang:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(tuiGuangPush)]) {
        [self.delegate tuiGuangPush];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
