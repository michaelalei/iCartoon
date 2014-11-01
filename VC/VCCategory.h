//
//  VCCategory.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-7-31.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPictureList.h"

@interface VCCategory : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView ;
    VCPictureList* _mPictureList ;
}

@property (retain,nonatomic) NSMutableArray* arrayData ;
@property (retain,nonatomic) NSMutableArray* arrayVCPicture ;


@end
