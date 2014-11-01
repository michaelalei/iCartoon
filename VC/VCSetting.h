//
//  VCSetting.h
//  iCartooniGame
//
//  Created by zhulei on 14-10-29.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCSetting : UIViewController<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate>
{
    UITableView*    _tableView ;
    NSMutableArray* _arrayData ;
}

@end
