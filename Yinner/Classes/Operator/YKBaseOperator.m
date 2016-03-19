//
//  YKBaseOperator.m
//  Yinner
//
//  Created by Maru on 15/12/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKBaseOperator.h"

@implementation YKBaseOperator

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer.timeoutInterval = 5.0;
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
    }
    return self;
    
}

@end
