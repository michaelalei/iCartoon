//
//  VCPictureTopicScrollShow.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-8-2.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCPictureTopicScrollShow : UIViewController<UIScrollViewDelegate>
{
    UIScrollView*    _mSV ;
    NSMutableArray*  _arrayData ;
}

@property (assign,nonatomic)  NSUInteger mTopicID ;

@end
