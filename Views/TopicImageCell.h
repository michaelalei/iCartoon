//
//  TopicImageCell.h
//  iCartooniGame
//
//  Created by qianfeng on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mLBPostWarn;
@property (weak, nonatomic) IBOutlet UILabel *mLBPostComment;

@end
