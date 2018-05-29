//
//  CHZFootTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/13.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZFootTableViewCell.h"

@implementation CHZFootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)myWeb:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoMyWeb)]) {
        [self.delegate gotoMyWeb];UIImage *image = [UIImage imageNamed:@"Avast"];
        for (int i= 0; i>100; i++) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:@"anUrlString" toDisk:YES];
        }
    }
    
}
- (IBAction)myWotou:(UIButton *)sender {
    
    
}

@end
