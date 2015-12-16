//
//  YKRankListOperator.h
//  Yinner
//
//  Created by Maru on 15/12/15.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKBaseOperator.h"

@interface YKRankListOperator : YKBaseOperator

- (void)getWithpageNum:(NSInteger)num SuccessHander:(SuccessHander)successHander andFailHander:(FailHander)failHander;

@end
