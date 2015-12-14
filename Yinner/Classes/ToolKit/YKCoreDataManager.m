//
//  CoreDataManager.m
//  Yinner
//
//  Created by Maru on 15/6/1.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKCoreDataManager.h"

@implementation YKCoreDataManager

singleton_implementation(YKCoreDataManager)


#pragma mark - life cycle
- (instancetype)init
{
    if (self == [super init]) {
        
        [self setup];
    }
    
    return self;
}


#pragma markr - 初始化
- (void)setup
{
    //搭建环境
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    //设置数据库路径
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databaseDir = [documentDir stringByAppendingString:@"/DataBase"];
    //创建一个DateBase文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:databaseDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dataPath = [databaseDir stringByAppendingString:@"/MediaData.sqlite"];
    NSURL *dataURL = [NSURL fileURLWithPath:dataPath];
    
    //设置异常处理
    NSError *error = nil;
    NSPersistentStore *store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dataURL options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"初始化数据库失败1" format:@"%@",[error localizedDescription]];
    }
    
    //初始化上下文
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:_coordinator];
    
}

#pragma mark - private method
- (void)insertEntityWithLocationMediaModel:(YKLocationMediaModel *)model
{
    [self insertEntityWithLocationMediaModel:model WithEntityName:@"Media"];
}

- (void)insertEntityWithLocationMediaModel:(YKLocationMediaModel *)model WithEntityName:(NSString *)name
{
    NSManagedObject *media = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:_context];
    
    //赋值
    [media setValue:model.cover forKey:@"cover"];
    [media setValue:model.name forKey:@"name"];
    [media setValue:model.origin forKey:@"origin"];
    [media setValue:model.time forKey:@"time"];
    [media setValue:model.titleurl forKey:@"titleurl"];
    [media setValue:model.url forKey:@"url"];
    
    NSError *error = nil;
    BOOL success = [_context save:&error];
    if (!success) {
        [NSException raise:@"添加数据库时出现错误！" format:@"%@",[error localizedDescription]];
    }
}

- (void)queryAllDataBase
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Media" inManagedObjectContext:_context];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *result = [_context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *entity in result) {
        NSLog(@"name:%@",[entity valueForKey:@"url"]);
    }
}

- (NSArray *)queryEntityWithEntityName:(NSString *)name
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:_context];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *result = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        debugLog(@"%@",error.description);
    }
    
    return result;
}

- (void)deleteDataWithEntity:(NSManagedObject *)entity
{
    [_context deleteObject:entity];
    
    NSError *error = nil;
    
    [_context save:&error];
    
    if (error) {
        [NSException raise:@"删除数据库数据出错！" format:@"%@",[error localizedDescription]];
    }
}
@end
