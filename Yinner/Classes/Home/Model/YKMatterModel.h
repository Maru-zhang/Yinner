//
//  YKMatterModel.h
//  Yinner
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YKMatterRoles;

@interface YKMatterModel : NSObject
/** 封面 */
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, assign) NSInteger catalog;
/** 角色 */
@property (nonatomic, strong) NSArray<YKMatterRoles *> *roles;
/** 来自 */
@property (nonatomic, copy) NSString *from;
/** 字幕URL */
@property (nonatomic, copy) NSString *srturl;
/** 用户ID */
@property (nonatomic, assign) NSInteger userid;
/** 有个鸟用 */
@property (nonatomic, copy) NSString *videourl_iqiyi;
/** 资源URL */
@property (nonatomic, copy) NSString *sourceurl;
/** 视频URL */
@property (nonatomic, copy) NSString *videourl;
/** 资源名 */
@property (nonatomic, copy) NSString *title;
/** 发布时间 */
@property (nonatomic, copy) NSString *video_time;
/** 用户数 */
@property (nonatomic, assign) NSInteger use_count;
/** 资源ID */
@property (nonatomic, assign) NSInteger sourceid;
/** 上传人 */
@property (nonatomic, copy) NSString *username;

@end


@interface YKMatterRoles : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *simaple_name;

@property (nonatomic, assign) NSInteger gender;

@end

