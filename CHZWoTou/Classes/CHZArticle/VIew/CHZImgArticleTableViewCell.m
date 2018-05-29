//
//  CHZImgArticleTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/24.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZImgArticleTableViewCell.h"
#import "CHZBookArticle.h"

@interface CHZImgArticleTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *topImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *AutorName;
@property (weak, nonatomic) IBOutlet UILabel *lookNum;
@property (weak, nonatomic) IBOutlet UIView *sepline;

@end
@implementation CHZImgArticleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    
    
    CGSize cellSize = self.size;
    cellSize.height = CGRectGetMaxY(_sepline.frame)+1;
    self.size = cellSize;
    HZLog(@"%f",cellSize.height);
 
}

- (void)setArticelData:(CHZBookArticle *)art{
    
    if (art) {
        if (art.thumbnail.length) {
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",API_MAIN,art.thumbnail];
            HZLog(@"%@",strUrl);
            self.topImg.image = [UIImage getImageFromUrl:[NSURL URLWithString:strUrl] imgViewWidth:self.topImg.width imgViewHeight:self.topImg.height];
            //[self.topImg sd_setImageWithURL:[NSURL URLWithString:@"http://ceshi.wt668.com/public/uploads/images/20161209/d76cee4596a2d276fd2883f1035b7e61.png"] placeholderImage:[UIImage imageNamed:@""]];
            self.topImg.image = [self cutImage:self.topImg.image];
        }else{
            self.topImg.backgroundColor = CHZNavigationBarColor;
        }
        self.titleLable.text = art.title;
        self.contentLable.text = art.bookArtDescription;
        self.AutorName.text = art.auther;
        self.lookNum.text = art.comments;
    }
    
}


//根据宽高剪切图片

//+(UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height;




- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (self.topImg.size.width / self.topImg.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * self.topImg.size.height / self.topImg.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * self.topImg.size.width / self.topImg.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    UIImage *reImg = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    return reImg;
}


/*
-(void)setBookArticle:(CHZBookArticle *)bookArticle{
    self.bookArticle = bookArticle;
    if (bookArticle) {
        if (bookArticle.thumbnail.length) {
            [self.topImg setImage:[UIImage imageNamed:bookArticle.thumbnail]];
        }
        self.titleLable.text = bookArticle.title;
        self.textLabel.text = bookArticle.bookArtDescription;
        self.AutorName.text = bookArticle.auther;
        self.lookNum.text = bookArticle.comments;
        
        
    }
}
 
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
