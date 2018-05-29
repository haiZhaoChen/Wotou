//
//  CHZBookCollectionViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/23.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZBookVideo;
@protocol CHZCollectionViewForDetailDelegate <NSObject>

@optional

- (void)bookTextPush:(CHZBookVideo *)cellData;
- (void)bookMusicPush:(CHZBookVideo *)cellData;
- (void)bookVideoPush:(CHZBookVideo *)cellData;

@end


@interface CHZBookCollectionViewController : UICollectionViewController

/**
 *  delegate
 */
@property (nonatomic, weak)id<CHZCollectionViewForDetailDelegate> delegate;

@end
