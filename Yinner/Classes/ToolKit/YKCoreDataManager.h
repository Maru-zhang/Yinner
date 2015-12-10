//
//  CoreDataManager.h
//  Yinner
//
//  Created by Maru on 15/6/1.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Singleton.h"
#import "YKLocationMediaModel.h"

@interface YKCoreDataManager : NSObject

singleton_interface(YKCoreDataManager)

@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;


- (void)insertEntityWithLocationMediaModel:(YKLocationMediaModel *)model;
/**
 *    根据实体名插入数据
 *
 *    @param model 模型
 *    @param name  实体名称
 */
- (void)insertEntityWithLocationMediaModel:(YKLocationMediaModel *)model WithEntityName:(NSString *)name;
/**
 *    查询所有的数据库
 */
- (void)queryAllDataBase;
/**
 *    根据实体名称查询数据库，返回结果数组
 *
 *    @param name 实体名称
 *
 *    @return 结果数组
 */
- (NSArray *)queryEntityWithEntityName:(NSString *)name;
/**
 *    删除一个实体
 *
 *    @param entity 实体
 */
- (void)deleteDataWithEntity:(NSManagedObject *)entity;

@end
