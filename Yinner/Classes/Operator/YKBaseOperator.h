//
//  YKBaseOperator.h
//  Yinner
//
//  Created by Maru on 15/12/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

typedef void(^SuccessHander)(id responseObject);
typedef void(^FailHander)(NSError *error);

#import <Foundation/Foundation.h>


@interface YKBaseOperator : NSObject

@property (nonatomic,copy) NSString *host;
@property (nonatomic,strong) NSMutableArray *parmaters;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end
