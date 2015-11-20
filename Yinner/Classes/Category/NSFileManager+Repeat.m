//
//  NSFileManager+Repeat.m
//  Yinner
//
//  Created by Maru on 15/6/2.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "NSFileManager+Repeat.h"

@implementation NSFileManager (Repeat)

- (void)removeRepeatFileWithPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]) {
        NSError *error = nil;
        [manager removeItemAtPath:path error:&error];
        
        if (error) {
            [NSException raise:@"覆盖操作失败！" format:@"%@",[error localizedDescription]];
        }
    }
}

@end
