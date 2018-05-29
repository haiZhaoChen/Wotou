//
//  CHZCommentFrames.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/17.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHZCommentModel;
/**  固定边距 */
#define KIconImgBorder 8
/**  tool 字体大小 */
#define KToolFont 15
/**  nick 字体大小 */
#define KNickFont 15
/**  time 字体大小 */
#define KTimeFont 12
/**  正文 字体大小 */
#define KTextFont 17

@interface CHZCommentFrames : NSObject

@property (nonatomic, assign, readonly)CGRect topImgViewF;

/**
 *  头像imgView尺寸
 */
@property (nonatomic, assign, readonly)CGRect IconImgF;

/**
 *  姓名Label尺寸
 */
@property (nonatomic, assign, readonly)CGRect nameLabelF;

/**
 *  时间Label尺寸
 */
@property (nonatomic, assign, readonly)CGRect timeLabelF;

/**
 *  点赞尺寸
 */
@property (nonatomic, assign, readonly)CGRect praiseBtnF;
/**
 *  数量尺寸
 */
@property (nonatomic, assign, readonly)CGRect numLBF;

/**
 *  文字内容尺寸
 */
@property (nonatomic, assign, readonly)CGRect textLabelF;



/**
 *  数据模型
 */
@property (nonatomic, strong)CHZCommentModel *statusInfo;


/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly)CGFloat cellHeight;


@end
