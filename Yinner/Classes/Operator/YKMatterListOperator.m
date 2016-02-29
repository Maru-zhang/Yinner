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

- (void)getTopicResponseWithSuccessHandler:(SuccessHander)successHandler andFailureHandler:(FailHander)failureHandler {
    [self.manager GET:@"http://api.peiyinxiu.com/v2.0/GetHotSource?appkey=3e8622117aee570a&v=4.1.17&uid=0&token=&pg=1&sign=dbae81d617c3975a4ac5b2745a02bff7" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *result = [YKMatterModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        
        successHandler(result);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureHandler(error);
    }];
}

@end
