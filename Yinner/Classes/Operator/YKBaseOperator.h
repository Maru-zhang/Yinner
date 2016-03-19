//
//  YKBaseOperator.h
//  Yinner
//
//  Created by Maru on 15/12/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

typedef void(^SuccessHander)(NSMutableArray *resultArray);
typedef void(^FailHander)(NSError *error);

#define kAPPKEY @"3e8622117aee570a"
#define kAPPV @"4.1.17"

#import <Foundation/Foundation.h>


@interface YKBaseOperator : NSObject

@property (nonatomic,copy) NSString *host;
@property (nonatomic,strong) NSDictionary *parmaters;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end
