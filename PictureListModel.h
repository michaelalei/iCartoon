//
//  PictureListModel.h
//  iCartooniGame
//
//  Created by zhulei on 14-11-1.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface PictureListModel : NSManagedObject

@property (nonatomic, retain) NSString * mAuthor;
@property (nonatomic, retain) NSString * mImagePath;
@property (nonatomic, retain) NSString * mTitle;
@property (nonatomic, retain) NSNumber * mIsFirstShowImage;
@property (nonatomic, retain) NSString * mTID;
@property (nonatomic, retain) NSString * mComment;
@property (nonatomic, retain) UIImage  * mImage ;
@property (nonatomic, retain) NSString * mCatID ;

+(BOOL)  isHaveTopic:(NSString*) tID ;
+(NSManagedObject*) getTopicByID:(NSString*) tID;

-(void) saveToCD ;
-(void) readRromCDByID;



@end
