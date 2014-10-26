//
//  VCRecomendArt.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-7-31.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCPictureList.h"

@interface VCRecomendArt : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView ;
}

@property (retain,nonatomic) NSMutableArray* arrayData ;

@end
