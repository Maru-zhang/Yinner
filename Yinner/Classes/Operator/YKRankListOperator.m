//
//  YKRankListOperator.m
//  Yinner
//
//  Created by Maru on 15/12/15.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKRankListOperator.h"
#import "YKRankListModel.h"

@implementation YKRankListOperator

- (instancetype)init {
    if (self = [super init]) {
        self.host = @"http://api.peiyinxiu.com/v3.0/RankFilms";
    }
    return self;
}

- (void)getWithpageNum:(NSInteger)num SuccessHander:(SuccessHander)successHander andFailHander:(FailHander)failHander {
    
    NSDictionary *paramaters = @{
                                   @"appkey": kAPPKEY,
                                   @"v": kAPPV,
                                   @"token": @"",
                                   @"uid": @"",
                                   @"g_type": @"1",
                                   @"r_type": @"2",
                                   @"pg": @"1",
                                   @"sign": @"418384faa89095078da1f1b7c1300f92",
                                   @"ccode": @""
                                   };
    
    [self.manager GET:self.host parameters:paramaters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successHander([YKRankListModel mj_objectArrayWithKeyValuesArray:json[@"data"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHander(error);
    }];
}

@end
