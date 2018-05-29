//
//  CHZQRCodeTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZQRCodeTableViewCell.h"
@interface CHZQRCodeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImg;

@end

@implementation CHZQRCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setQr_code:(NSString *)qr_code{
    _qr_code = qr_code;
    [self.qrCodeImg sd_setImageWithURL:[NSURL URLWithString:qr_code] placeholderImage:[UIImage imageNamed:@"qr_code"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
