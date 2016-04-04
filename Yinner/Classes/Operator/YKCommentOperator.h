//
//  YKCommentOperator.h
//  Yinner
//
//  Created by Maru on 16/4/4.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKBaseOperator.h"
@interface YKCommentOperator : YKBaseOperator

- (void)fetchCommentResponseWithSuccessHandler:(SuccessHander)successHandler andFailureHandler:(FailHander)failureHandler;

@end
