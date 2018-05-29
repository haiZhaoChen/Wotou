//
//  CHZBookArticle.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/24.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookArticle.h"

@implementation CHZBookArticle
/*
 @property (nonatomic, copy)NSString *add_time;
 @property (nonatomic, copy)NSString *auther;
 @property (nonatomic, copy)NSString *bookArtDescription;
 @property (nonatomic, copy)NSString *comments;
 @property (nonatomic, copy)NSString *bookArtId;
 @property (nonatomic, copy)NSString *read_counts;
 @property (nonatomic, copy)NSString *share_counts;
 @property (nonatomic, copy)NSString *thumbnail;
 @property (nonatomic, copy)NSString *title;
 */

+ (instancetype)articleDataWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        
        if (dict[@"auther"] == [NSNull null]) {
            self.auther = @"佚名";
        }else{
            self.auther = dict[@"auther"];
        }
        if (dict[@"bookArtDescription"] == [NSNull null]) {
            self.bookArtDescription = @"";
        }else{
            self.bookArtDescription = dict[@"description"];
        }
        if (dict[@"comments"] == [NSNull null]) {
            self.comments = @"";
        }else{
            self.comments = [NSString stringWithFormat:@"%@",dict[@"comments"]];
        }
        if (dict[@"bookArtId"] == [NSNull null]) {
            self.bookArtId = @"";
        }else{
            self.bookArtId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        }
        if (dict[@"read_counts"] == [NSNull null]) {
            self.read_counts = @"";
        }else{
            self.read_counts = [NSString stringWithFormat:@"%@",dict[@"read_counts"]];
        }
        if (dict[@"share_counts"] == [NSNull null]) {
            self.share_counts = @"";
        }else{
            self.share_counts = [NSString stringWithFormat:@"%@",dict[@"share_counts"]];
        }
        if (dict[@"thumbnail"] == [NSNull null]) {
            self.thumbnail = @"";
        }else{
            self.thumbnail = dict[@"thumbnail"];
        }
        if (dict[@"title"] == [NSNull null]) {
            self.title = @"";
        }else{
            self.title = dict[@"title"];
        }
  
    }
    
    return self;
}


@end
