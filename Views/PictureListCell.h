//
//  PictureListCell.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-8-2.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *mMainImage;
@property (strong, nonatomic) IBOutlet UILabel *mLBAuthor;

@property (strong, nonatomic) IBOutlet UILabel *mLBTitle;
@property (strong, nonatomic) IBOutlet UILabel *mLBComment;
@property (weak, nonatomic) IBOutlet UIButton *mLBReport;

@end
