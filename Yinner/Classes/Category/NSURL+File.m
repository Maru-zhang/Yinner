//
//  NSURL+File.m
//  Yinner
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "NSURL+File.h"

@implementation NSURL (File)

+ (NSURL *)getMaterialByZipURL:(NSURL *)url andType:(NSString *)type {
    
    NSString *fileName = [[url lastPathComponent] stringByDeletingPathExtension];
    
    NSString *videoPath;
    
    if ([type isEqualToString:@"mp3"]) {
        videoPath = [[ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:fileName] stringByAppendingString:[NSString stringWithFormat:@"/1x.%@",type]];
    }else {
        videoPath = [[ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:fileName] stringByAppendingString:[NSString stringWithFormat:@"/1.%@",type]];
    }
    
    return [NSURL fileURLWithPath:videoPath];
}


@end
