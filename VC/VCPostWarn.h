//
//  VCPostWarn.h
//  iCartooniGame
//
//  Created by qianfeng on 14-9-27.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface VCPostWarn : UIViewController<ASIHTTPRequestDelegate>
- (IBAction)pressWarn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *mMainImage;

@property (retain,nonatomic) UIImage* mImage ;
@property (weak, nonatomic) IBOutlet UILabel *mLBAuthor;
@property (weak, nonatomic) IBOutlet UILabel *mLBTitle;
@property (weak, nonatomic) IBOutlet UITextView *mTVContent;
- (IBAction)pressBack:(id)sender;

@property (retain,nonatomic) NSString* mTopicID ;

@end
