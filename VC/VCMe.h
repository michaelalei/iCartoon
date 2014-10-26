//
//  VCMe.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCMe : UIViewController<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate>
{
    UITableView*    _tableView ;
    NSMutableArray* _arrayData ;
    
    BOOL            _isLogin ;
}

@end
