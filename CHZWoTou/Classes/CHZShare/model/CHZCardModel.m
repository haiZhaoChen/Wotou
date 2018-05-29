//
//  CHZCardModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/11.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZCardModel.h"

/*@property (nonatomic, copy)NSString *head_pic;
 @property (nonatomic, copy)NSString *nickname;
 @property (nonatomic, copy)NSString *qr_code;
 @property (nonatomic, copy)NSString *tel;
 @property (nonatomic, copy)NSString *website;
 @property (nonatomic, copy)NSString *uid;
 @property (nonatomic, copy)NSString *cardId;*/

@implementation CHZCardModel


+ (instancetype)cardModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.head_pic = [NSString stringWithFormat:@"%@%@",API_IMGMAIN,dict[@"head_pic"]];
        self.nickname = dict[@"nickname"];
        self.qr_code = [NSString stringWithFormat:@"%@%@",API_IMGMAIN,dict[@"qr_code"]];
        self.tel = [NSString stringWithFormat:@"%@",dict[@"tel"]];
        if (dict[@"website"] != [NSNull null]) {
//            self.website = API_DEFAULTWEB;
            self.website = dict[@"website"];
        }else{
            self.website = API_DEFAULTWEB;
        }
        
        self.uid = [NSString stringWithFormat:@"%@",dict[@"uid"]];
        self.cardId = [NSString stringWithFormat:@"%@",dict[@"cardId"]];
    }
    
    return self;
}

@end
