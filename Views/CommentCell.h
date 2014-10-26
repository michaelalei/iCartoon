//
//  CommentCell.h
//  iCartooniGame
//
//  Created by qianfeng on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mAuthorLB;
@property (weak, nonatomic) IBOutlet UILabel *mDateLB;
@property (weak, nonatomic) IBOutlet UILabel *mCotentLB;

@end
