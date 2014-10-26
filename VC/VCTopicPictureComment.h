//
//  VCTopicPictureComment.h
//  iCartooniGame
//
//  Created by qianfeng on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCTopicPictureComment : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView* _mSV ;
    UITableView*  _mTableView ;
}

@property (assign,nonatomic) NSUInteger mTopicID ;
@property (retain,nonatomic) NSMutableArray* mArrayData ;
@property (retain,nonatomic) NSMutableDictionary* mDicDataRoot ;
@property (retain,nonatomic) UIImage*   mMainImage ;

@end
