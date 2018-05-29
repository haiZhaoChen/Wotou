//
//  CHZADImgModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/9.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZADImgModel.h"

@implementation CHZADImgModel

+ (instancetype)ADImgModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        if (dict[@"ad_img1"] != [NSNull null]) {
            self.ad_img1 = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"ad_img1"]];
        }else{
            self.ad_img1 = @"";
        }
        
        if (dict[@"ad_img2"] != [NSNull null]) {
            self.ad_img2 = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"ad_img2"]];
        }else{
            self.ad_img2 = @"";
        }
        
        if (dict[@"ad_img3"] != [NSNull null]) {
            self.ad_img3 = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"ad_img3"]];
        }else{
            self.ad_img3 = @"";
        }
    }
    
    return self;
}


/*
 @property (nonatomic, copy)NSString *ad_img1;
 @property (nonatomic, copy)NSString *ad_img2;
 @property (nonatomic, copy)NSString *ad_img3;
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.ad_img1 = [aDecoder decodeObjectForKey:@"ad_img1"];
        self.ad_img2 = [aDecoder decodeObjectForKey:@"ad_img2"];
        self.ad_img3 = [aDecoder decodeObjectForKey:@"ad_img3"];
       
        
    }
    return self;
    
}
/**
 * 编码
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.ad_img1 forKey:@"ad_img1"];
    [aCoder encodeObject:self.ad_img2 forKey:@"ad_img2"];
    [aCoder encodeObject:self.ad_img3 forKey:@"ad_img3"];
    
    
}

@end
