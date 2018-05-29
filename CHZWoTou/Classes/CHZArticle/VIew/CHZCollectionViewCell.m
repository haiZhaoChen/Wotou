//
//  CHZCollectionViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/24.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZCollectionViewCell.h"
#import "CHZBookVideo.h"


@interface CHZCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIButton *bookImgBtn;
@property (weak, nonatomic) IBOutlet UIView *bookDetailBtns;
@property (weak, nonatomic) IBOutlet UILabel *bookName;

@property (nonatomic, strong)CHZBookVideo *book;


//@property (nonatomic, assign)BOOL isShowDetail;

@end

@implementation CHZCollectionViewCell
- (IBAction)bookImgBtnClick:(UIButton *)sender {
    
    
    //添加动画
    if (self.isShowDetail) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bookImgBtn.transform = CGAffineTransformIdentity;
            self.bookDetailBtns.transform = CGAffineTransformIdentity;
        }];
         
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.bookImgBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.5, 0.5),
                                                                CGAffineTransformMakeTranslation(0.0, 0.0));
            
//            self.bookImgBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.3, 1.3),
//                                                                CGAffineTransformMakeTranslation(0.0, 100.0));
            self.bookDetailBtns.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.3, 1.3),
                                                                    CGAffineTransformMakeTranslation(0.0, 0.0));
        }];
    }
    
    self.isShowDetail = !self.isShowDetail;
    
    
    if (self.isShowDetail){
    if ([self.delegate respondsToSelector:@selector(saveShowDetailCell:)]) {
        [self.delegate saveShowDetailCell:self];
    }
    
    }
    
    
    
}

- (void)endShowDetail{
    //添加动画
    [UIView animateWithDuration:0.5 animations:^{
        self.bookImgBtn.transform = CGAffineTransformIdentity;
        self.bookDetailBtns.transform = CGAffineTransformIdentity;
    }];
    self.isShowDetail = !self.isShowDetail;
    
    
}


- (void)setBookVideoData:(CHZBookVideo *)book{
    _book = book;
    if (book.book_image.length) {
        NSString *strUrl = book.book_image;
        HZLog(@"%@",strUrl);
        UIImage *img = [UIImage getImageFromUrl:[NSURL URLWithString:strUrl] imgViewWidth:self.bookImgBtn.width imgViewHeight:self.bookImgBtn.height];
        [self.bookImgBtn setImage:img forState:UIControlStateNormal];
    }
    if (book.book_name.length) {
        self.bookName.text = book.book_name;
    }
    
}
- (IBAction)bookTextBtnClick:(UIButton *)sender {
    HZLog(@"点击了书，文字文章");
    if ([self.delegate respondsToSelector:@selector(bookTextBtnClick:)]) {
        [self.delegate bookTextBtnClick:self.book];
    }
    
}

- (IBAction)bookMusBtnClick:(id)sender {
    HZLog(@"点击了mus，文字文章");
    if ([self.delegate respondsToSelector:@selector(bookMusicBtnClick:)]) {
        [self.delegate bookMusicBtnClick:self.book];
    }
    
}

- (IBAction)bookVideoBtnClick:(id)sender {
    HZLog(@"点击了video，文字文章");
    if ([self.delegate respondsToSelector:@selector(bookVideoBtnClick:)]) {
        [self.delegate bookVideoBtnClick:self.book];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
