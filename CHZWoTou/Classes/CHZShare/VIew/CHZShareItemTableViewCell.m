//
//  CHZShareItemTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/21.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZShareItemTableViewCell.h"

@interface CHZShareItemTableViewCell()

@property (nonatomic, weak)UIImageView *logImg;
@property (nonatomic, weak)UILabel *titleLable;
@property (nonatomic, weak)UILabel *contentText;
@property (nonatomic, weak)UIImageView *browseImg;
@property (nonatomic, weak)UILabel *browseNum;

@property (nonatomic, weak)UIImageView *sharedImg;
@property (nonatomic, weak)UILabel *sharedNum;

@end

@implementation CHZShareItemTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"shared";
    CHZShareItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CHZShareItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //设置cell的被点击效果为None
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = CHZGlobalBg;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addInfoView];
    }
    
    return self;
}

- (void)addInfoView{
    UIImageView *logImg = [[UIImageView alloc] init];
    [logImg setImage:[UIImage imageNamed:@""]];
    self.logImg = logImg;
    
    UILabel *titleLable = [[UILabel alloc] init];
    [titleLable setFont:CHZTitleFont];
    titleLable.numberOfLines = 0;
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = CHZBarButtonTitleColor;
    titleLable.backgroundColor = [UIColor clearColor];
    
    self.titleLable = titleLable;
    
    UILabel *contentText = [[UILabel alloc] init];
    [contentText setFont:CHZTextFont];
    contentText.numberOfLines = 2;
    contentText.textAlignment = NSTextAlignmentLeft;
    contentText.textColor = CHZRGBColor(39, 39, 39);
    contentText.backgroundColor = [UIColor clearColor];
    self.contentText = contentText;
    
    UIImageView *browseImg = [[UIImageView alloc] init];
    browseImg.image = [UIImage imageNamed:@""];
    self.browseImg = browseImg;
    
    UILabel *browseNum = [[UILabel alloc] init];
    self.browseNum = browseNum;
    browseNum.font = CHZTextFont;
    browseNum.textAlignment = NSTextAlignmentLeft;
    browseNum.textColor = CHZRGBColor(2, 2, 2);
    
    UIImageView *sharedImg = [[UIImageView alloc] init];
    sharedImg.image = [UIImage imageNamed:@""];
    self.sharedImg = sharedImg;
    
    UILabel *sharedNum = [[UILabel alloc] init];
    self.sharedNum = sharedNum;
    sharedNum.font = CHZTextFont;
    sharedNum.textAlignment = NSTextAlignmentLeft;
    sharedNum.textColor = CHZRGBColor(2, 2, 2);
    
    [self.contentView addSubview:logImg];
    [self.contentView addSubview:titleLable];
    [self.contentView addSubview:contentText];
    [self.contentView addSubview:browseImg];
    [self.contentView addSubview:sharedImg];
    [self.contentView addSubview:browseNum];
    [self.contentView addSubview:sharedNum];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
