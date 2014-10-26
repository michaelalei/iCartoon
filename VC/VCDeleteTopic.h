//
//  VCDeleteTopic.h
//  iCartooniGame
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetDownload.h"
#import "MyImageDownload.h"
#import "ASIHTTPRequest.h"

@interface VCDeleteTopic : UIViewController<UITableViewDataSource,UITableViewDelegate,NetDownloadDelegate,MyImageDownloadDelegate,UISearchBarDelegate,ASIHTTPRequestDelegate>
{
    UITableView*    _tableView ;
    NSMutableArray* _arrayData ;
    
    UISearchDisplayController* _sdc ;
    
    NSUInteger   _topicLastID ;
    
    UIButton*    _btnDelete ;
    
    UISearchBar* _searchBar ;
    
    NSString*    _curDeleteID ;
    
    NSMutableArray* _arrayImageDown ;
    NSMutableArray* _arrayConnect ;
    NSMutableArray* _arrayASIRequest ;
}

@end
