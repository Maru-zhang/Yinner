//
//  YKBrowseListOperator.h
//  Yinner
//
//  Created by Maru on 15/12/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//


#define tempURL @"http://api.peiyinxiu.com/v3.0/GetRecommendFilms?appkey=3e8622117aee570a&v=4.1.17&token=&uid=0&type=3&pg=1&sign=5ec1551557809a3e0e89d15e7a81e07b"

#import "YKBaseOperator.h"

@interface YKBrowseListOperator : YKBaseOperator

- (instancetype)initWithParmaters:(NSMutableArray *)parmaters;

- (void)getWithSuccessHander:(SuccessHander)successHander andFailHander:(FailHander)failHander;

@end
