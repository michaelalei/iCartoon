//
//  PictureListModel.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-9-14.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PictureListModel : NSObject

@property (retain,nonatomic) NSString* mAuthor ;
@property (retain,nonatomic) NSString* mTitle ;

@property (retain,nonatomic) NSString* mImagePath ;
@property (retain,nonatomic) NSString* mComment ;
@property (retain,nonatomic) NSString* mTID ;
@property (retain,nonatomic) UIImage*  mImage ;

@property (assign,nonatomic) BOOL      mIsFirstShowImage ;

@end
