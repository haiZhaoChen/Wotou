//
//  CHZInterviewCollectionViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZInterviewCollectionViewCell.h"
#import "CHZinterviewModel.h"

@interface CHZInterviewCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIButton *bookImgBtn;
@property (weak, nonatomic) IBOutlet UIView *bookDetailBtns;
@property (weak, nonatomic) IBOutlet UILabel *bookName;


@property (nonatomic, strong)CHZinterviewModel *interView;

@end

@implementation CHZInterviewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)interviewImgBtnClick:(UIButton *)sender {
    
    
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

- (void)setInterviewData:(CHZinterviewModel *)interviewData{
    _interView = interviewData;
    if (interviewData.thumbnail.length) {
        NSString *strUrl = interviewData.thumbnail;
        HZLog(@"%@",strUrl);
        UIImage *img = [UIImage getImageFromUrl:[NSURL URLWithString:strUrl] imgViewWidth:self.bookImgBtn.width imgViewHeight:self.bookImgBtn.height];
        [self.bookImgBtn setImage:img forState:UIControlStateNormal];
    }
    if (interviewData.title.length) {
        self.bookName.text = interviewData.title;
    }
}

- (IBAction)interviewTextBtnClick:(UIButton *)sender {
    HZLog(@"点击了书，文字文章");
    
    if ([self.delegate respondsToSelector:@selector(interviewTextBtnClick:)]) {
        [self.delegate interviewTextBtnClick:self.interView];
    }
    
}

- (IBAction)interviewMusBtnClick:(id)sender {
    HZLog(@"点击了mus，文字文章");
    if ([self.delegate respondsToSelector:@selector(interviewMusicBtnClick:)]) {
        [self.delegate interviewMusicBtnClick:self.interView];
    }
    
}

- (IBAction)interviewVideoBtnClick:(id)sender {
    HZLog(@"点击了video，文字文章");
    if ([self.delegate respondsToSelector:@selector(interviewVideoBtnClick:)]) {
        [self.delegate interviewVideoBtnClick:self.interView];
    }
    
}

@end
