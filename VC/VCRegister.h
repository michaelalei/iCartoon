//
//  VCRegister.h
//  iCartoom爱动漫
//
//  Created by qianfeng on 14-9-15.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCRegister : UIViewController<UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData* _data ;
    UIActivityIndicatorView* _waitAIV ;
    BOOL _isOK ;
}
@property (retain, nonatomic) IBOutlet UITextField *mTFUesrName;
@property (retain, nonatomic) IBOutlet UITextField *mTFPassword;
@property (retain, nonatomic) IBOutlet UITextField *mTFPasswordComfirm;
@property (retain,nonatomic) UIViewController* vcLogin ;
- (IBAction)pressRegister:(id)sender;

- (IBAction)pressBack:(id)sender;@end
