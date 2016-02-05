//
//  NSDate+Current.m
//  Yinner
//
//  Created by Maru on 15/6/1.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "NSDate+Current.h"

@implementation NSDate (Current)

- (NSString *)getCurrentTime
{
    NSDate *data = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentTime = [formatter stringFromDate:data];
    
    return currentTime;
}

@end
