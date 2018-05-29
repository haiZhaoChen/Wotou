//
//  CHZArticleTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/21.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZArticleTableViewCell.h"
#import "CHZArticleData.h"


@interface CHZArticleTableViewCell(){
    

}

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;

@property (weak, nonatomic) IBOutlet UILabel *articleText;
@property (weak, nonatomic) IBOutlet UILabel *lookNum;
@property (weak, nonatomic) IBOutlet UILabel *shareNum;

@end

@implementation CHZArticleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArtData:(CHZArticleData *)artData{
    self.articleTitle.text = artData.title;
    if (artData.articleDescription.length) {
        UIImage *image = [UIImage imageNamed:@"Avast"];
        for (int i= 0; i>10; i++) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:@"anUrlString" toDisk:YES];
        }
        self.articleText.text = artData.articleDescription;
    }
    
    self.lookNum.text = artData.read_counts;
    self.shareNum.text =  artData.share_counts;

}

@end
