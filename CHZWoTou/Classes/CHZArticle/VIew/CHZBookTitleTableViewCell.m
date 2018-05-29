//
//  CHZBookTitleTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookTitleTableViewCell.h"
@interface CHZBookTitleTableViewCell(){
    
}
@property (weak, nonatomic) IBOutlet UIButton *interviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *articleBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookBtn;

@property (nonatomic, assign)NSUInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSArray *allOnbtnNames;
@property (nonatomic, strong) NSArray *allOffbtnNames;


@end

@implementation CHZBookTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _btns = [NSMutableArray arrayWithObjects:self.articleBtn,self.bookBtn,self.interviewBtn, nil];
    _allOnbtnNames = [NSArray arrayWithObjects:@"meiwen",@"dushu",@"fangtan", nil];
    _allOffbtnNames = [NSArray arrayWithObjects:@"meiwen_off",@"dushu_off",@"fangtan_off", nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)interviewClick:(UIButton *)sender {
    if (self.currentIndex != sender.tag) {
        
        [self scrollToCenterWithIndex:sender.tag];
        if ([self.delegate respondsToSelector:@selector(titleBtnClickWithIndex:)]) {
            [self.delegate titleBtnClickWithIndex:2];
        }
    }
}

- (IBAction)articleBtnClick:(UIButton *)sender {
    if (self.currentIndex != sender.tag) {
        
        [self scrollToCenterWithIndex:sender.tag];
        if ([self.delegate respondsToSelector:@selector(titleBtnClickWithIndex:)]) {
            [self.delegate titleBtnClickWithIndex:0];
        }
    }
}
- (IBAction)bookBtnClick:(UIButton *)sender {
    
    if (self.currentIndex != sender.tag) {
        
        [self scrollToCenterWithIndex:sender.tag];
        if ([self.delegate respondsToSelector:@selector(titleBtnClickWithIndex:)]) {
            [self.delegate titleBtnClickWithIndex:1];
        }
    }
}

- (void)scrollToCenterWithIndex:(NSUInteger)index{
    UIButton *lastBtn = _btns[_currentIndex];
    
    [lastBtn setBackgroundImage:[UIImage imageNamed:_allOffbtnNames[_currentIndex]] forState:UIControlStateNormal];
    self.currentIndex = index;
    UIButton *selectBtn = _btns[index];
    [selectBtn setBackgroundImage:[UIImage imageNamed:_allOnbtnNames[index]] forState:UIControlStateNormal];
    
    
    HZLog(@"调用一个scroll");
    
}



@end
