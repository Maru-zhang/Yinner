//
//  NSString+File.m
//  ShopAssistant
//
//  Created by maru on 15-2-3.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

-(NSString *)fileNameAppend:(NSString *)append
{
    NSString *name = [self stringByDeletingPathExtension];
    
    NSString *newName = [name stringByAppendingString:append];
    
    NSString *extension = [self pathExtension];
    
    return [newName stringByAppendingPathExtension:extension];
}

@end
