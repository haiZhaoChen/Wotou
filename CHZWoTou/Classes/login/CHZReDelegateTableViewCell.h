//
//  CHZReDelegateTableViewCell.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/6.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ReDelegateCell @"ReDelegateCell"
@interface CHZReDelegateTableViewCell : UITableViewCell

@property (nonatomic, copy)NSString *titleStr;

@property (weak, nonatomic) IBOutlet UITextField *conTF;
@property (weak, nonatomic) IBOutlet UIImageView *warningImg;

@end
