//
//  YKMatterModel.h
//  Yinner
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YKMatterModel : NSObject


@property (nonatomic, copy) NSString *srt_url;

@property (nonatomic, assign) long long audio_id;

@property (nonatomic, copy) NSString *audio_url;

@property (nonatomic, copy) NSString *from;

@property (nonatomic, copy) NSString *video_time;

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger srt_count;

@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, assign) long long srt_id;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, assign) NSInteger audio_count;

@end


