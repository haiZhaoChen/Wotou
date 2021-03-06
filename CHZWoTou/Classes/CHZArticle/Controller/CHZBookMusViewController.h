//
//  CHZBookMusViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/27.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHZBookVideo;
@class CHZinterviewModel;
@class STKAudioPlayer;
@interface CHZBookMusViewController : UIViewController

//- (instancetype)initWithBookVideo:(CHZBookVideo *)cellData;
- (instancetype)initWithBookInterview:(CHZinterviewModel *)interviewData;

@property (nonatomic, strong)CHZBookVideo *cellData;
@property (nonatomic, strong)CHZinterviewModel *interviewData;

+(instancetype)shareBookMusViewController;

@property(nonatomic,strong)STKAudioPlayer *player;

@end
