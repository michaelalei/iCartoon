//
//  VCAddTopic.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "LeoLoadingView.h"


@class VCPictureList ;

@interface VCAddTopic :UIViewController<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextFieldDelegate,
ASIHTTPRequestDelegate,
UIAlertViewDelegate>
{
    UIButton* _btnSend ;
}
@property (retain,nonatomic) UIImage*     mMainImage ;
@property (retain,nonatomic) UIButton*    mBtnAdd ;
@property (retain,nonatomic) UITextField*  mTFTopicTitle ;
@property (retain,nonatomic) UIScrollView* mSV ;
@property (assign,nonatomic) NSUInteger    mCategoryID ;
@property (retain,nonatomic) VCPictureList* mPC ;

@property (retain,nonatomic) LeoLoadingView* mLoadingView ;

@property (retain,nonatomic) NSString*    mCurDeleteID ;

@end
