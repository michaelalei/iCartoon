//
//  CDManager.m
//  iCartooniGame
//
//  Created by zhulei on 14-11-1.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CDManager.h"
#import <CoreData/CoreData.h>

@implementation CDManager

static CDManager* mSingleton  = nil;


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


-(NSArray*) fetchTopicModelByCat:(NSString*) catID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PictureListModel" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                         initWithKey:@"mTID" ascending:NO];
   // NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
   //                                      initWithKey:@"secretIdentity" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptor1, nil];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    //[fetchRequest setFetchBatchSize:20];
    if (![catID isEqualToString:@"0"])
    {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"mCatID == %@",catID] ;
         [fetchRequest setPredicate:predicate] ;
    }

    NSError *error = nil;
    NSArray *objecs = [_managedObjectContext executeFetchRequest: fetchRequest error:&error];
    
    NSArray* returnArray =nil ;
    if (objecs != nil && objecs.count>0)
    {
       returnArray = [[NSArray alloc] initWithArray:objecs] ;
    }
    
    return returnArray ;

}

-(NSArray*) fetchTopicModelByCount:(NSUInteger) countLatest
{
    NSArray* arrayAll = [self fetchTopicModelByCat:@"0"] ;
    
    NSMutableArray* arrayReturn = [[NSMutableArray alloc] init] ;
    for (int i = 0 ; i < arrayAll.count; i++)
    {
        if(i == countLatest){
            break ;
        }
        [arrayReturn addObject:arrayAll[i]] ;
    }
    
    return arrayReturn ;
}



-(void) deleteTopicModelOldest
{
    
    int countDelete = 20 ;
    NSArray* arrayAll = [self fetchTopicModelByCat:@"0"] ;
    
    NSMutableArray* arrayReturn = [[NSMutableArray alloc] init] ;
    for (int i = 0 ; i < arrayAll.count; i++)
    {
        if(i == countDelete){
            break ;
        }
        [arrayReturn addObject:arrayAll[i]] ;
    }
    
    for (NSManagedObject* obj in arrayReturn)
    {
           [_managedObjectContext deleteObject:obj];
            
    }
     
     // Save the context.
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
         
         // Update to handle the error appropriately.
         
         NSLog(@"Unresolved error %@, %@",error,[error userInfo]);

         exit(-1); // Fail
         
     }
}

-(id) init
{
    self = [super init] ;
    if (self) {
        _mSaveLock = [[NSLock alloc] init] ;
    }
    return self ;
    
}

+(id) getSingleton
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        mSingleton = [[CDManager alloc]init];
        
    });
    return mSingleton ;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
