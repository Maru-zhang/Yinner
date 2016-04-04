//
//  YKCommentOperator.m
//  Yinner
//
//  Created by Maru on 16/4/4.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKCommentOperator.h"
#import "YKCommentModel.h"

@implementation YKCommentOperator

- (instancetype)init {
    if (self = [super init]) {
        self.host = @"http://api.peiyinxiu.com/v1.0/comment?appkey=3e8622117aee570a&v=5.0.25&oid=19127072&cid=0&sign=f23dded2aeaf001a2301c857fcf92ef1";
    }
    return self;
}


- (void)fetchCommentResponseWithSuccessHandler:(SuccessHander)successHandler andFailureHandler:(FailHander)failureHandler {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:self.host parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *result = [YKCommentItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        successHandler(result);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureHandler(error);
    }];
}



@end
