//
//  YKChannelOperator.h
//  Yinner
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKBaseOperator.h"

typedef enum : NSUInteger {
    /** 喜剧 */
    YKChannerTypeComedy,
    /** 卡通 */
    YKChannerTypeCartoon,
    /** 剧场 */
    YKChannerTypeTheatre,
    /** 电视 */
    YKChannerTypeTV,
    /** 方言 */
    YKChannerTypeLocalism,
    /** 解说 */
    YKChannerTypeComment
} YKChannerType;

@interface YKChannelOperator : YKBaseOperator

- (void)getResponseWithType:(YKChannerType)type SuccessHandler:(SuccessHander)successHandler andFailureHandler:(FailHander)failureHandler;


@end
