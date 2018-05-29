//
//  CHZInterviewCollectionViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/12.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHZinterviewModel;
@protocol InterviewCollectionViewControllerDelegate <NSObject>

@optional

- (void)interviewTextPush:(CHZinterviewModel *)cellData;
- (void)interviewMusicPush:(CHZinterviewModel *)cellData;
- (void)interviewVideoPush:(CHZinterviewModel *)cellData;

@end


@interface CHZInterviewCollectionViewController : UICollectionViewController

/**
 *  delegate
 */
@property (nonatomic, weak)id<InterviewCollectionViewControllerDelegate> delegate;

@end
