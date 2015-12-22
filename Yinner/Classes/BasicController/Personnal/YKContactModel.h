//
//  YKContactModel.h
//  Yinner
//
//  Created by Maru on 15/8/13.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKContactModel : NSObject

/** 用户名称 */
@property (nonatomic, strong) NSString *myUserName;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

+ (YKContactModel *)configWithMessageArray:(NSArray <EMMessage *>*)array;
/**
 *    根据模型添加数据
 *
 *    @param obj 模型
 */
- (void)insertMessageModel:(EMMessage *)obj;
/**
 *    根据字典添加数据
 *
 *    @param dic 字典
 */
- (void)addSpecifiedItem:(NSDictionary *)dic;

@end
