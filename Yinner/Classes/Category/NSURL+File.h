//
//  NSURL+File.h
//  Yinner
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKMatterModel.h"

typedef enum : NSUInteger {
    // 字幕
    YKMatterTypeSRT,
    // 视频
    YKMatterTypeMP4,
    // 背景音乐
    YKMatterTypeMP3,
    // 录音
    YKMatterTypeRec,
    
} YKMatterType;

@interface NSURL (File)

+ (NSURL *)urlWithMatter:(YKMatterModel *)model andType:(YKMatterType)type;

@end
