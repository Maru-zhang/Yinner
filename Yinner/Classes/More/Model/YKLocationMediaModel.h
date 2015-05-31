//
//  LocationMediaModel.h
//  Yinner
//
//  Created by apple on 15/5/31.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKLocationMediaModel : NSObject

@property (nonatomic,copy) NSString *mediaName;
@property (nonatomic,copy) NSString *mediaURL;

+ (YKLocationMediaModel *)locationModelWithName:(NSString *)name andURL:(NSString *)url;

@end
