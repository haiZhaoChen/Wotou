//
//  CHZSharedCollectionViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/15.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZSharedItemData;
@class CHZTitleName;
@class CHZSaveSharedData;
@class CHZSharedCollectionViewCell;
@class CHZArticleDetailViewController;
@class CHZNoticeModel;

@protocol CHZSharedCollectionViewCellDelegate <NSObject>

- (void)artcleListDataWithCell:(CHZSharedCollectionViewCell *)cell dictData:(NSDictionary<NSString* , CHZSaveSharedData* >* )dict;
//提示条更新
- (void)updateNum:(NSUInteger)num;

- (void)clickToNotice:(NSString *)nId;

- (void)artclePushDetailView:(CHZSharedCollectionViewCell *)cCell andTableVCell:(UITableViewCell *)tCell andPushVC:(CHZArticleDetailViewController *)VC;

- (void)TokenPass;
- (void)noMoneyGoBack;

@end

@interface CHZSharedCollectionViewCell : UICollectionViewCell

+ (instancetype)returnCollectionViewCell:(UICollectionView* )curCollectionView
                                                  identifier:(NSString* )identifierString
                                                   indexPath:(NSIndexPath* )indexPath
                                                   listModel:(CHZSharedItemData* )model;

- (void)beginRefreshCurCell;
- (void)endRefreshCurCell;

- (void)configurationPostBackDictionary:(CHZTitleName *)titleName dictData:(NSDictionary<NSString* , CHZSaveSharedData* >* )dict;

@property (nonatomic, weak)id<CHZSharedCollectionViewCellDelegate> delegate;

@end
