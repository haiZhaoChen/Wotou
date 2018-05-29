//
//  CHZChangeInfoViewController.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/5.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHZChangeInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *theTextF;
@property (nonatomic, copy)NSString *theText;

@property (nonatomic, assign)BOOL isPhone;
@property (nonatomic, assign)NSUInteger type;



@property (nonatomic, copy)NSString *theName;
@property (nonatomic, copy)NSString *theWarning;

@end
