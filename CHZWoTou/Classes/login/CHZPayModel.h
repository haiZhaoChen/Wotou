//
//  CHZPayModel.h
//  CHZWoTou
//
//  Created by 陈海召 on 2017/3/16.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHZPayModel : NSObject

/*
 appid = wxdd059f98e09921e2;
 "mch_id" = 1432590602;
 "nonce_str" = D0LBPUEZMYk1mAn3;
 "prepay_id" = wx2017031615434361a0e963e20290570190;
 "result_code" = SUCCESS;
 "return_code" = SUCCESS;
 "return_msg" = OK;
 sign = 40FE93D5AB57439BFFC6CD55D7C34C45;
 timestamp = 1489650224;
 "trade_type" = APP;
 */

@property (nonatomic, copy)NSString *appid;
@property (nonatomic, copy)NSString *mch_id;
@property (nonatomic, copy)NSString *nonce_str;
@property (nonatomic, copy)NSString *prepay_id;
@property (nonatomic, copy)NSString *return_msg;
@property (nonatomic, copy)NSString *sign;
@property (nonatomic, copy)NSString *timestamp;
@property (nonatomic, copy)NSString *trade_type;


@end
