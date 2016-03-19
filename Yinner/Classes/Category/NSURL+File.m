//
//  NSURL+File.m
//  Yinner
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "NSURL+File.h"

@implementation NSURL (File)


+ (NSURL *)urlWithMatter:(YKMatterModel *)model andType:(YKMatterType)type {
    
    NSString *fileName;
    NSString *result;
    
    switch (type) {
        case YKMatterTypeSRT:
            fileName =  [model.srt_url lastPathComponent];
            result = [ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:fileName];
            break;
            
        case YKMatterTypeMP3:
            fileName = [model.audio_url lastPathComponent];
            result = [ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:fileName];
            break;
        case YKMatterTypeMP4:
            fileName = [model.video_url lastPathComponent];
            result = [ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:fileName];
            break;
        case YKMatterTypeRec:
            fileName = [[[model.audio_url lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
            result = [ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:fileName];
        default:
            break;
    }
    
    return [NSURL fileURLWithPath:result];
}


@end
