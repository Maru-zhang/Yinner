//
//  NSURL+File.h
//  Yinner
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (File)

+ (NSURL *)getMaterialByZipURL:(NSURL *)url andType:(NSString *)type;

@end
