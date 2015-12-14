//
//  YKBrowseListOperator.m
//  Yinner
//
//  Created by Maru on 15/12/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKBrowseListOperator.h"

@implementation YKBrowseListOperator

- (instancetype)initWithParmaters:(NSMutableArray *)parmaters {
    if (self = [super init]) {
        self.host = kAPIHOST;
        self.parmaters = parmaters;
    }
    return self;
}


- (void)getWithSuccessHander:(SuccessHander)successHander andFailHander:(FailHander)failHander {
    
    [self.manager GET:tempURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        successHander(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHander(error);
    }];
}



@end
