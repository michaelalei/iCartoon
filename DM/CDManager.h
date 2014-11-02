//
//  CDManager.h
//  iCartooniGame
//
//  Created by zhulei on 14-11-1.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CDManager : NSObject

+(id) getSingleton ;

//数据映射对象类,将OC中的类对象,映射为Sqlite中的一个字段内容
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据模型管理对象
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//存储对象,负责将数据存储到文件中
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain,nonatomic) NSLock* mSaveLock ;

//存盘操作
- (void)saveContext;
//获得本地数据库路径
- (NSURL *)applicationDocumentsDirectory;

//查找主题对象
-(NSArray*) fetchTopicModelByCat:(NSString*) catID ;

-(NSArray*) fetchTopicModelByCount:(NSUInteger) countLatest ;

//删除早起数据对象
-(void) deleteTopicModelOldest ;

@end
