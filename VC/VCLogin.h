//
//  VCLogin.h
//  iCartoom爱动漫
//
//  Created by qianfeng on 14-9-15.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBox.h"
#import "VCMe.h"

@interface VCLogin : UIViewController<NSURLConnectionDataDelegate,
NSURLConnectionDelegate,
UIAlertViewDelegate>
{
    BOOL _isRecondPassword ;
    BOOL _isRecondUsername ;
    NSMutableData* _data ;
    int _isOK ;
}

@property (retain, nonatomic) IBOutlet UITextField *mTFUserName;
@property (retain, nonatomic) IBOutlet UITextField *mTFPassword;
- (IBAction)pressLogin:(id)sender;
- (IBAction)pressRegister:(id)sender;
@property (retain, nonatomic) IBOutlet CheckBox *mCBUserName;
@property (retain, nonatomic) IBOutlet CheckBox *mCBPassword;
- (IBAction)pressBack:(id)sender;



@end
