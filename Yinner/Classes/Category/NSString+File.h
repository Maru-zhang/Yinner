//
//  NSString+File.h
//  ShopAssistant
//
//  Created by maru on 15-2-3.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (File)

+ (NSString *)getMediaPathWithModelURL:(NSString *)url;
- (NSString *)fileNameAppend:(NSString *)append;
- (NSString *)replaceExtension:(NSString *)extension;


@end
