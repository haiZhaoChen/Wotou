//
//  CHZTuiInfoTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZTuiInfoTableViewCell.h"
#import "CHZTGInfoModel.h"
@interface CHZTuiInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;


@end

@implementation CHZTuiInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfoModel:(CHZTGInfoModel *)infoModel{
    _infoModel = infoModel;
    self.timeLB.text = infoModel.add_time;
    self.nameLable.text = infoModel.message;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
