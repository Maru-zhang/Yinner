//
//  YKMatterListOperator.m
//  Yinner
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKMatterListOperator.h"
#import "YKMatterModel.h"
@implementation YKMatterListOperator

- (instancetype)init {
    if (self = [super init]) {
        self.host = [NSString stringWithFormat:@"%@/allmatter/",LOCAL_API];
    }
    return self;
}

- (void)getTopicResponseWithSuccessHandler:(SuccessHander)successHandler andFailureHandler:(FailHander)failureHandler {
    
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [self.manager GET:self.host parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *result = [YKMatterModel mj_objectArrayWithKeyValuesArray:dic[@"datas"]];
        
        successHandler(result);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureHandler(error);
    }];

}

@end
