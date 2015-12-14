//
//  LGConstant.h
//  Yinner
//
//  Created by Maru on 15/12/10.
//  Copyright © 2015年 Alloc. All rights reserved.
//




#define DOCUMRNT_DIR [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject]

#define DOCUMENT_DIR_STR [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define MY_MEDIA_DIR [DOCUMRNT_DIR URLByAppendingPathComponent:@"My_Media"]

#define MY_MEDIA_DIR_STR [DOCUMENT_DIR_STR stringByAppendingPathComponent:@"My_Media"]