//
//  CHZSharedTableViewCell.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZSharedTableViewCell.h"

@interface CHZSharedTableViewCell(){
    
    __weak IBOutlet UIButton *firstBtn;
    
    __weak IBOutlet UIButton *secondBtn;
    
    __weak IBOutlet UIButton *thirdBtn;
    
    __weak IBOutlet UIButton *forthBtn;
 
}

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSArray *allOnbtnNames;
@property (nonatomic, strong) NSArray *allOffbtnNames;

@end

@implementation CHZSharedTableViewCell


- (IBAction)firstBtnClick:(UIButton *)sender {
    if (self.currentIndex != sender.tag) {
       
        [self scrollToCenterWithIndex:sender.tag];
        if ([self.delegate respondsToSelector:@selector(titleBtnClickWithIndex:)]) {
            [self.delegate titleBtnClickWithIndex:0];
        }
    }
    
}


- (IBAction)secondBtnClick:(UIButton *)sender {
    if (self.currentIndex != sender.tag) {
        [self scrollToCenterWithIndex:sender.tag];
        if ([self.delegate respondsToSelector:@selector(titleBtnClickWithIndex:)]) {
            [self.delegate titleBtnClickWithIndex:1];
        }
    }
     
}


- (IBAction)thirdBtnClick:(UIButton *)sender {
    if (self.currentIndex != sender.tag) {
        [self scrollToCenterWithIndex:sender.tag];
        if ([self.delegate respondsToSelector:@selector(titleBtnClickWithIndex:)]) {
            [self.delegate titleBtnClickWithIndex:2];
        }
    }
    
}


- (IBAction)forthBtnClick:(UIButton *)sender {
    if (self.currentIndex != sender.tag) {
        [self scrollToCenterWithIndex:sender.tag];
        if ([self.delegate respondsToSelector:@selector(titleBtnClickWithIndex:)]) {
            [self.delegate titleBtnClickWithIndex:3];
        }
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _btns = [NSMutableArray arrayWithObjects:firstBtn,secondBtn,thirdBtn,forthBtn, nil];
    _allOnbtnNames = [NSArray arrayWithObjects:@"guanli",@"lizhi",@"gaoxiao",@"qita", nil];
    _allOffbtnNames = [NSArray arrayWithObjects:@"guanli_off",@"lizhi_off",@"gaoxiao_off",@"qita_off", nil];
    
    [self->firstBtn setBackgroundImage:[UIImage imageNamed:@"guanli"] forState:UIControlStateNormal];

}

- (void)scrollToCenterWithIndex:(NSUInteger)index{
    UIButton *lastBtn = _btns[_currentIndex];
    [lastBtn setBackgroundImage:[UIImage imageNamed:_allOffbtnNames[_currentIndex]] forState:UIControlStateNormal];
    self.currentIndex = index;
    UIButton *selectBtn = _btns[index];
    [selectBtn setBackgroundImage:[UIImage imageNamed:_allOnbtnNames[index]] forState:UIControlStateNormal];

    
    
    HZLog(@"调用一个scroll");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
