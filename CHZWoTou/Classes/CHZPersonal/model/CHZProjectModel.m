//
//  CHZProjectModel.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/2/8.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZProjectModel.h"

@implementation CHZProjectModel


+ (instancetype)projectWithDict:(NSDictionary *)dict{
    return  [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        if (dict[@"xm_img1"] != [NSNull null]) {
            self.xm_img1 = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"xm_img1"]];
        }else{
            self.xm_img1 = @"";
        }
        if (dict[@"xm_title1"] != [NSNull null]) {
            self.xm_title1 = dict[@"xm_title1"];
        }else{
            self.xm_title1 = @"";
        }
        
        if (dict[@"xm_img2"] != [NSNull null]) {
            self.xm_img2 = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"xm_img2"]];
        }else{
            self.xm_img2 = @"";
        }
        if (dict[@"xm_title2"] != [NSNull null]) {
            self.xm_title2 = dict[@"xm_title2"];
        }else{
            self.xm_title2 = @"";
        }
        if (dict[@"xm_img3"] != [NSNull null]) {
            self.xm_img3 = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"xm_img3"]];
        }else{
            self.xm_img3 = @"";
        }
        if (dict[@"xm_title3"] != [NSNull null]) {
            self.xm_title3 = dict[@"xm_title3"];
        }else{
            self.xm_title3 = @"";
        }
        if (dict[@"xm_img4"] != [NSNull null]) {
            self.xm_img4 = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"xm_img4"]];
        }else{
            self.xm_img4 = @"";
        }
        if (dict[@"xm_title4"] != [NSNull null]) {
            self.xm_title4 = dict[@"xm_title4"];
        }else{
            self.xm_title4 = @"";
        }
        
    }
    return self;
}

/*
 @property (nonatomic, copy)NSString *xm_img1;
 @property (nonatomic, copy)NSString *xm_title1;
 @property (nonatomic, copy)NSString *xm_img2;
 @property (nonatomic, copy)NSString *xm_title2;
 @property (nonatomic, copy)NSString *xm_img3;
 @property (nonatomic, copy)NSString *xm_title3;
 @property (nonatomic, copy)NSString *xm_img4;
 @property (nonatomic, copy)NSString *xm_title4;
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.xm_img1 = [aDecoder decodeObjectForKey:@"xm_img1"];
        self.xm_title1 = [aDecoder decodeObjectForKey:@"xm_title1"];
        self.xm_img2 = [aDecoder decodeObjectForKey:@"xm_img2"];
        self.xm_title2 = [aDecoder decodeObjectForKey:@"xm_title2"];
        self.xm_img3 = [aDecoder decodeObjectForKey:@"xm_img3"];
        self.xm_title3 = [aDecoder decodeObjectForKey:@"xm_title3"];
        self.xm_img4 = [aDecoder decodeObjectForKey:@"xm_img4"];
        self.xm_title4 = [aDecoder decodeObjectForKey:@"xm_title4"];

    }
    return self;
    
    
}
/**
 * 编码
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.xm_img1 forKey:@"xm_img1"];
    [aCoder encodeObject:self.xm_title1 forKey:@"xm_title1"];
    [aCoder encodeObject:self.xm_img2 forKey:@"xm_img2"];
    [aCoder encodeObject:self.xm_title2 forKey:@"xm_title2"];
    [aCoder encodeObject:self.xm_img3 forKey:@"xm_img3"];
    [aCoder encodeObject:self.xm_title3 forKey:@"xm_title3"];
    [aCoder encodeObject:self.xm_img4 forKey:@"xm_img4"];
    [aCoder encodeObject:self.xm_title4 forKey:@"xm_title4"];
    
}

@end
