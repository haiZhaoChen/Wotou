//
//  CHZCollectionViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/24.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZCollectionViewCell;
@class CHZBookVideo;

@protocol CHZCollectionViewCellDelegate <NSObject>

- (void)saveShowDetailCell:(CHZCollectionViewCell *)cell;


@optional

- (void)bookTextBtnClick:(CHZBookVideo *)cellData;
- (void)bookMusicBtnClick:(CHZBookVideo *)cellData;
- (void)bookVideoBtnClick:(CHZBookVideo *)cellData;


@end

@interface CHZCollectionViewCell : UICollectionViewCell

/**
 *  代理
 */
@property (nonatomic, weak)id<CHZCollectionViewCellDelegate> delegate;

@property (nonatomic, assign)BOOL isShowDetail;

- (void)endShowDetail;

- (void)setBookVideoData:(CHZBookVideo *)book;





@end
