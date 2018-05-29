//
//  CHZInterviewCollectionViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZinterviewModel;
@class CHZInterviewCollectionViewCell;

@protocol InterviewCellDelegate <NSObject>

- (void)saveShowDetailCell:(CHZInterviewCollectionViewCell *)cell;


@optional

- (void)interviewTextBtnClick:(CHZinterviewModel *)cellData;
- (void)interviewMusicBtnClick:(CHZinterviewModel *)cellData;
- (void)interviewVideoBtnClick:(CHZinterviewModel *)cellData;


@end



@interface CHZInterviewCollectionViewCell : UICollectionViewCell

/**
 *  代理
 */
@property (nonatomic, weak)id<InterviewCellDelegate> delegate;

@property (nonatomic, assign)BOOL isShowDetail;

- (void)setInterviewData:(CHZinterviewModel *)interviewData;

- (void)endShowDetail;

@end
