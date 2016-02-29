//
//  NSDictionary+Parmaters.m
//  Yinner
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "NSDictionary+Parmaters.h"

@implementation NSDictionary (Parmaters)

+ (NSDictionary *)dictionaryWithSign:(NSString *)sign andCcode:(NSString *)ccode {
    return @{@"appkey": @"3e8622117aee570a",
             @"v": @"4.1.17",
             @"sigin": sign,
             @"uid": @"0",
             @"token": @"0",
             @"ccode": ccode,
             @"pg": @"1",
             @"acode": @""};
}

@end
