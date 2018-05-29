//
//  CHZCollectionViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZTitleName;

@protocol CHZCollectionViewControllerDelegate <NSObject>

- (void)ScrollViewDidEndWithIndex:(NSInteger)index;

- (void)updateCellNum:(NSUInteger)num;

- (void)noticeADWebVIew:(NSString *)nId;

- (void)TokenMessage:(NSUInteger)code;

@end

@interface CHZCollectionViewController : UICollectionViewController


@property (nonatomic, strong)NSArray<CHZTitleName *> *itemArr;

@property (nonatomic, weak)id<CHZCollectionViewControllerDelegate> delegate;


- (void)beginRefreshWithIndex:(NSInteger)index;

@end
