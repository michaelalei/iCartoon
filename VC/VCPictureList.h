//
//  VCPictureList.h
//  iCartooniGame
//
//  Created by Zhu Lei on 14-7-31.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetDownload.h"
#import "MyImageDownload.h"
#import "VCAddTopic.h"

@interface VCPictureList : UIViewController<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NetDownloadDelegate,
MyImageDownloadDelegate,
UIAlertViewDelegate,
ASIHTTPRequestDelegate>
{
    UITableView* _tableView ;
    
    VCAddTopic*  _vcAddTopic ;
    
    NSUInteger   _topicLastID ;
    
    UIBarButtonItem* _barDeleteItem;
}

@property (retain,nonatomic) NSMutableArray* arrayRequest ;
@property (retain,nonatomic) NSMutableArray* arrayDelegateConnect ;
@property (retain,nonatomic) NSMutableArray* arrayData ;
@property (retain,nonatomic) NSMutableArray* arrayNetDownlaod ;
@property (retain,nonatomic) NSMutableArray* arrayImageDownload ;
//分类索引
@property (assign,nonatomic) NSUInteger      categoryID ;

-(void)  loadDataFromServer ;

@end
