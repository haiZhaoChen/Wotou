//
//  CHZReDelegateTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZReDelegateTableViewCell.h"
@interface CHZReDelegateTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleName;


@end

@implementation CHZReDelegateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] init];
    
    
}

- (void)setTitleStr:(NSString *)titleStr{
    self.titleName.text = titleStr;
    _titleStr = titleStr;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
