//
//  NSString+FileName.m
//  Yinner
//
//  Created by Maru on 15/6/3.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "NSString+FileName.h"

@implementation NSString (FileName)

+ (NSString *)getFileNameWithPath:(NSString *)path
{
    NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
    
    return fileName;
}

@end
