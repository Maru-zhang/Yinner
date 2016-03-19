//
//  URLConstant.h
//  Yinner
//
//  Created by Maru on 15/12/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#define kAPIHOST @"http://api.peiyinxiu.com"

#if TARGET_IPHONE_SIMULATOR
#define LOCAL_API @"http://localhost:5000"
#elif TARGET_OS_IPHONE
#define LOCAL_API @"http://localhost:5000"
#endif