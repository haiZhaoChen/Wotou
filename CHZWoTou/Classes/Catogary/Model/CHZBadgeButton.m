//
//  CHZBadgeButton.m
//  CHZGov_Affairs
//
//  Created by 陈海召 on 16/4/14.
//  Copyright © 2016年 陈海召. All rights reserved.
//

#import "CHZBadgeButton.h"

@implementation CHZBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setBackgroundImage:[UIImage resizedImage:@"main_badge"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted { }

- (void)setValue:(NSString *)value
{
    _value = [value copy];
    
    // 1.设置可见性
    if (value.length) {
        self.hidden = NO;
        
        // 2.设置尺寸
        CGRect frame = self.frame;
        frame.size.height = self.currentBackgroundImage.size.height;
        if (value.length > 1) {
            NSMutableDictionary *sizeDic = [NSMutableDictionary dictionary];
            sizeDic[NSFontAttributeName] = self.titleLabel.font;
            CGSize valueSize = [value sizeWithAttributes:sizeDic];
            frame.size.width = valueSize.width + 10;
        } else {
            frame.size.width = self.currentBackgroundImage.size.width;
        }
        [super setFrame:frame];
        
        // 3.内容
        if ([value intValue]< 99) {
            [self setTitle:value forState:UIControlStateNormal];
        }else{
            [self setTitle:@"99+" forState:UIControlStateNormal];
        }
        
    } else {
        self.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size = self.frame.size;
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds
{
    bounds.size = self.bounds.size;
    [super setBounds:bounds];
}

@end
