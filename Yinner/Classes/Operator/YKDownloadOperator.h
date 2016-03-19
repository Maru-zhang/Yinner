//
//  YKDownloadOperator.h
//  Yinner
//
//  Created by Maru on 16/3/17.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKBaseOperator.h"
#import "YKMatterModel.h"

@interface YKDownloadOperator : YKBaseOperator

- (void)downloadWithMatter:(YKMatterModel *)model successHandler:(SuccessHander)successHandler failureHandler:(FailHander)failurehandler;

@end
