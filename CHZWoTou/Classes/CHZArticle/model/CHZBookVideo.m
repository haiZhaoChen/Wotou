//
//  CHZBookVideo.m
//  CHZWoTou
//
//  Created by 陈海召 on 2017/1/25.
//  Copyright © 2017年 陈海召. All rights reserved.
//

#import "CHZBookVideo.h"

@implementation CHZBookVideo


+ (instancetype)bookVideoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
    
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        
        self.bookId = [NSString stringWithFormat:@"%@",dict[@"id"]];;
        self.book_image = [NSString stringWithFormat:@"%@%@",API_MAIN,dict[@"book_image"]];
        self.book_name = dict[@"book_name"];
        
    }
    
    return self;
}


@end
