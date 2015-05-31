//
//  LocationMediaModel.m
//  Yinner
//
//  Created by apple on 15/5/31.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKLocationMediaModel.h"

@implementation YKLocationMediaModel

+ (YKLocationMediaModel *)locationModelWithName:(NSString *)name andURL:(NSString *)url
{
    YKLocationMediaModel *model = [[YKLocationMediaModel alloc] init];
    
    model.mediaName = name;
    model.mediaURL = url;
    
    return model;
}

@end
