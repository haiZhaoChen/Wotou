//
//  CHZMapSelectTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MapSelectCell @"MapSelectCell"

@protocol MapSelectTableViewCellDelegate <NSObject>

- (void)selectMap;

@end

@interface CHZMapSelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *mapName;
/**
 *  delegate
 */
@property (nonatomic, weak)id<MapSelectTableViewCellDelegate> delegate;

@end
