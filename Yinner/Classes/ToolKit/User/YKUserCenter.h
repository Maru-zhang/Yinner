//
//  YKUserCenter.h
//  Yinner
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <sqlite3.h>

typedef void(^loginHander)();


@interface YKUserCenter : NSObject



@property (nonatomic) NSString *test;

- (void)test:(loginHander) a;

@end
