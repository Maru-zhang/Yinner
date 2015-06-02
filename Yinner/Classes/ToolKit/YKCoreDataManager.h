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

//插入数据库
- (void)insertEntityWithLocationMediaModel:(YKLocationMediaModel *)model;
//查询数据库
- (void)queryAllDataBase;
- (NSArray *)queryEntityWithEntityName:(NSString *)name;
//删除数据库
- (void)deleteDataWithEntity:(NSManagedObject *)entity;

@end
