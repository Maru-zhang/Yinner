//
//  YKMatterListOperator.h
//  Yinner
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKBaseOperator.h"

@interface YKMatterListOperator : YKBaseOperator
/**
 *  获取热门的资源
 *
 *  @param successHandler 成功处理
 *  @param failureHandler 失败处理
 */
- (void)getTopicResponseWithSuccessHandler:(SuccessHander)successHandler andFailureHandler:(FailHander)failureHandler;
@end
