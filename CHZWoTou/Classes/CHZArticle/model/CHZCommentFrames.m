//
//  CHZCommentFrames.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/17.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZCommentFrames.h"
#import "CHZCommentModel.h"

@implementation CHZCommentFrames

/**  icon 的固定宽高 */
#define KIconWH  cellWidth*0.14

- (void)setStatusInfo:(CHZCommentModel *)statusInfo{
    _statusInfo = statusInfo;
    
    //cell的宽度
    CGFloat cellWidth =  [UIScreen mainScreen].bounds.size.width;
    //topView
    CGFloat topW = cellWidth;
    CGFloat topX = 0;
    CGFloat topY = 0;
    
    //1.icon
    CGFloat iconImgX = KIconImgBorder;
    CGFloat iconImgY = KIconImgBorder;
    _IconImgF = CGRectMake(iconImgX, iconImgY, KIconWH, KIconWH);
    
    //2.nick
    //计算nickname的宽度
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:KNickFont];
    //传入数据，计算尺寸
    CGSize nickWH = [statusInfo.name sizeWithAttributes:dict];
    
    CGFloat nickX = CGRectGetMaxX(_IconImgF) +KIconImgBorder;
    CGFloat nickY = KIconImgBorder;
    _nameLabelF = (CGRect){{nickX,nickY},nickWH};
    
    //生成dele按扭
    _praiseBtnF = CGRectMake(cellWidth-35, nickY , 20, 20);
    
    _numLBF = CGRectMake(cellWidth - 83, nickY+2, 45, 20);
    
    //time
    CGFloat timeX = nickX;
    CGFloat timeY = CGRectGetMaxY(_nameLabelF)+KIconImgBorder;
    NSMutableDictionary *timeDict = [NSMutableDictionary dictionary];
    timeDict[NSFontAttributeName] = [UIFont systemFontOfSize:KTimeFont];
    
    //传入时间数据
    CGSize timeWH = (CGSize){150,15.4};
    _timeLabelF = (CGRect){{timeX,timeY},timeWH};
    
    
    
    
    //text
    CGFloat textX = 2*KIconImgBorder;
    CGFloat textY = CGRectGetMaxY(_IconImgF)+2*KIconImgBorder;
    
    //传入正文数据
    CGFloat textW = cellWidth - 4*KIconImgBorder;
    
    //    CGSize textSize = [self heightForString:statusInfo.content fontSize:KTextFont andWidth:textW];
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:KTextFont],NSFontAttributeName, nil];
    NSString *conText;
    if (statusInfo.reply.length > 0) {
        
        conText = [NSString stringWithFormat:@"%@\n\n%@:%@",statusInfo.content,statusInfo.reply_name,statusInfo.reply];
    }else{
        conText = statusInfo.content;
    }
    CGSize textSize = [conText boundingRectWithSize:CGSizeMake(textW, 500) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    _textLabelF = (CGRect){{textX,textY},textSize};
    

    
    CGFloat topH = CGRectGetMaxY(_textLabelF)+2*KIconImgBorder;
    
    _topImgViewF = CGRectMake(topX, topY, topW, topH);
    _cellHeight = CGRectGetMaxY(_topImgViewF);
    
}

@end
