//
//  LGConstant.h
//  Yinner
//
//  Created by Maru on 15/12/10.
//  Copyright © 2015年 Alloc. All rights reserved.
//




// URL地址
#define DOCUMRNT_DIR [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject]

#define CACHES_DIR [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject]

#define PREFERENCE_DIR [[[NSFileManager defaultManager] URLsForDirectory:NSPreferencePanesDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"my_perferenece.plist"]

// 字符串地址
#define DOCUMENT_DIR_STR [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define CACHES_DIR_STR [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define MY_MEDIA_DIR [DOCUMRNT_DIR URLByAppendingPathComponent:@"My_Media"]

#define MY_MEDIA_DIR_STR [DOCUMENT_DIR_STR stringByAppendingPathComponent:@"My_Media"]

#define ORIGIN_MEDIA_DIR_STR [CACHES_DIR_STR stringByAppendingPathComponent:@"Origin_media"]

#define MY_PREFERENCE_DIR_STR [[NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"my_perference.plist"]