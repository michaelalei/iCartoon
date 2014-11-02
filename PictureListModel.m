//
//  PictureListModel.m
//  iCartooniGame
//
//  Created by zhulei on 14-11-1.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "PictureListModel.h"
#import "CDManager.h"

@implementation PictureListModel

@synthesize mImage ;

@dynamic mAuthor;
@dynamic mImagePath;
@dynamic mTitle;
@dynamic mIsFirstShowImage;
@dynamic mTID;
@dynamic mComment;
@dynamic mCatID ;

+(NSManagedObject*) getTopicByID:(NSString*) tID
{
    CDManager* cdm = [CDManager getSingleton] ;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //
    NSEntityDescription *teamEntity = [NSEntityDescription entityForName:@"PictureListModel" inManagedObjectContext:cdm.managedObjectContext];
    [fetchRequest setEntity:teamEntity];
    //
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mTID == %@", tID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:10];
    //
    //存入NSData数据库
    NSError *error = NULL;
    NSArray *array = [cdm.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    for (PictureListModel* pm in array) {
        NSLog(@"pm ID = %@, title = %@",pm.mTID,pm.mTitle);
    }
    if (array && array.count >0)
    {
        return array[0] ;
    }
    else
    {
        return nil ;
    }
}

+(BOOL)  isHaveTopic:(NSString*) tID
{
//    CDManager* cdm = [CDManager getSingleton] ;
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    //
//    NSEntityDescription *teamEntity = [NSEntityDescription entityForName:@"PictureListModel" inManagedObjectContext:cdm.managedObjectContext];
//    [fetchRequest setEntity:teamEntity];
//    //
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mTID == %@", tID];
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setFetchLimit:10];
//    //
//    //存入NSData数据库
//    NSError *error = NULL;
//    NSArray *array = [cdm.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    if (error) {
//        NSLog(@"Error : %@\n", [error localizedDescription]);
//    }
//    
//    for (PictureListModel* pm in array) {
//        NSLog(@"pm ID = %@, title = %@",pm.mTID,pm.mTitle);
//    }
//    if (array && array.count >0)
    NSManagedObject* obj = [self getTopicByID:tID] ;
    if (obj != nil)
    {
        return YES ;
    }
    else
    {
        return NO ;
    }
}


-(void) saveToCD
{
    CDManager* cdm = [CDManager getSingleton] ;

    NSError *error = NULL;
    if (![cdm.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void) readRromCDByID
{
    
}

@end
