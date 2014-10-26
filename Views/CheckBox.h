//
//  CheckBox.h
//  iCartooniGame
//
//  Created by qianfeng on 14-8-7.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBox : UIControl
{
    UIImageView* _checkView ;
    UIImage*     _selectedImage ;
    UIImage*     _normalImage ;
    BOOL         _isON ;
    id           _target ;
    SEL          _action ;
}

@property (assign,nonatomic) BOOL on ;

@end
