//
//  CHZBgCell.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/16.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZBgCell.h"

@implementation CHZBgCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] init];
        self.backgroundView = bg;
        self.bg = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        self.selectedBackgroundView = selectedBg;
        self.selectedBg = selectedBg;
    }
    return self;
}
@end
