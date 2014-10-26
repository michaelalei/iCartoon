//
//  VCShowSingleImage.h
//  iCartooniGame
//
//  Created by qianfeng on 14-9-19.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyImageDownload.h"

@interface VCShowSingleImage : UIViewController<MyImageDownloadDelegate>
{
    UIImageView* _imageView ;
    UIActivityIndicatorView* _watingView ;
    
    CGPoint      _beginPT ;
}

@property (retain,nonatomic) NSString* mImagePath ;

@end
