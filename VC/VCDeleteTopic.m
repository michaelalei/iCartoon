//
//  VCDeleteTopic.m
//  iCartooniGame
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCDeleteTopic.h"
#import "PictureListModel.h"
#import "NetDownload.h"
#import "MyImageDownload.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

@interface VCDeleteTopic ()

@end

@implementation VCDeleteTopic

#pragma mark 初始化函数
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    //CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60)
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain] ;
    _tableView.delegate = self ;
    _tableView.dataSource = self;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, 320, 40)] ;
    //_sdc = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchBar.delegate = self ;
    
    //_searchBar.showsSearchResultsButton = YES ;
    _searchBar.showsCancelButton = YES ;
    
    UIView* bgHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 40)] ;
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btnBack.frame = CGRectMake(0, 0, 60, 40) ;
    [btnBack setTitle:@"返回" forState:UIControlStateNormal] ;
    [btnBack addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside] ;
    _btnDelete = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    _btnDelete.frame = CGRectMake(260, 0, 60, 40) ;
    [_btnDelete setTitle:@"删除" forState:UIControlStateNormal] ;
    [_btnDelete addTarget:self action:@selector(pressDelete) forControlEvents:UIControlEventTouchUpInside] ;

    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btnSearch.frame = CGRectMake(200, 0, 60, 40) ;
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal] ;
    [btnSearch addTarget:self action:@selector(pressSearch) forControlEvents:UIControlEventTouchUpInside] ;
    
    [bgHeadView addSubview:btnBack] ;
    [bgHeadView addSubview:_btnDelete] ;
    [bgHeadView addSubview:btnSearch] ;
    
    UILabel* labelUpdate = [[UILabel alloc] init] ;
    labelUpdate.frame = CGRectMake(0, 0, 320, 40) ;
    labelUpdate.userInteractionEnabled = YES ;
    labelUpdate.textAlignment = NSTextAlignmentCenter ;
    labelUpdate.font = [UIFont systemFontOfSize:14];
    labelUpdate.text= @"更多";
    labelUpdate.textColor = [UIColor blueColor] ;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMore:)] ;
    
    [labelUpdate addGestureRecognizer:tap] ;
    
    _tableView.tableFooterView  = labelUpdate ;
    
    [self.view addSubview:bgHeadView] ;
    
    [self.view addSubview:_tableView] ;
    [self.view addSubview:_searchBar] ;
    _searchBar.hidden = YES ;
    
    _arrayData = [[NSMutableArray alloc] init] ;
    
    _arrayConnect = [[NSMutableArray alloc] init] ;
    
    _arrayImageDown = [[NSMutableArray alloc] init] ;
    
    _arrayASIRequest = [[NSMutableArray alloc] init] ;
    
    //[ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    [self loadDataFromServer];
}

-(void) addConnect:(NSURLConnection *)connect
{
    [_arrayConnect addObject:connect] ;
}

-(void) loadDataFromServerNoASI
{
    int _categoryID = 0 ;
    
    NSString* strURL = [NSString stringWithFormat:@"http://121.40.93.230/appCATM/getLatestTopics.php?cat=%lu&number=50",(unsigned long)_categoryID] ;
    // NSURL* url = [NSURL URLWithString:strURL] ;
    
    NetDownload* down = [[NetDownload alloc] init] ;
    down.delegate = self ;
    down.tag = 1001 ;
    [down downloadData:strURL] ;
}

-(void) loadDataFromServer
{
    int _categoryID = 0 ;
    
    NSString* strURL = [NSString stringWithFormat:@"http://121.40.93.230/appCATM/getLatestTopics.php?cat=%lu&number=50",(unsigned long)_categoryID] ;
    // NSURL* url = [NSURL URLWithString:strURL] ;
    
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:strURL]] ;
    
    request.delegate = self ;
    
    [request setCachePolicy:ASIUseDefaultCachePolicy] ;
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy ];

    [request startAsynchronous] ;
    request.tag = 1001 ;
    [_arrayASIRequest addObject:request] ;
}


-(void) dealloc
{
    for (NSURLConnection* connect in _arrayConnect)
    {
        [connect cancel] ;
    }
    
    for (MyImageDownload* dw in _arrayImageDown) {
        dw.delegate = nil ;
    }
    
    for (ASIFormDataRequest* request in _arrayASIRequest) {
        [request cancel] ;
        request.delegate = nil ;
    }
}

#pragma mark 交互事件
-(void) tapMore:(UITapGestureRecognizer*) tap
{
    NSLog(@"more ...");
    int _categoryID = 0 ;
    NSString* strURL = [NSString stringWithFormat:@"http://121.40.93.230/appCATM/getMoreTopic.php?cat=%lu&number=50&startID=%lu",(unsigned long)_categoryID,_topicLastID] ;
    // NSURL* url = [NSURL URLWithString:strURL] ;
    
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:strURL]] ;
    
    request.delegate = self ;
    
    [request setCachePolicy:ASIUseDefaultCachePolicy] ;
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [request startAsynchronous] ;
    request.tag = 1003 ;
    [_arrayASIRequest addObject:request] ;
    
    /*
    NetDownload* down = [[NetDownload alloc] init] ;
    down.delegate = self ;
    //获取更多数据
    down.tag = 1003 ;
    [down downloadData:strURL] ;
     */
}

-(void) pressBack
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

-(void) pressDelete
{
        if ([_tableView isEditing] == NO)
        {
            [_tableView setEditing:YES] ;
            [_btnDelete setTitle:@"完成" forState:UIControlStateNormal];
        }
        else{
            [_tableView setEditing:NO] ;
            [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
        }
}

-(void) pressSearch
{
    if (_searchBar.hidden == YES)
    {
        [_tableView setEditing:NO] ;
        _tableView.frame = CGRectMake(0, 100, 320, self.view.bounds.size.height-100) ;
        _tableView.tableFooterView.hidden = YES ;
    }
    else
    {
        _tableView.frame = CGRectMake(0, 60, 320, self.view.bounds.size.height-60) ;
        _tableView.tableFooterView.hidden = NO ;
    }
    _searchBar.hidden = !_searchBar.hidden ;
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"1111");
    
    //int _categoryID = 0 ;
    
    NSInteger deleteID = [searchBar.text integerValue] ;
    
    if (deleteID == 0 )
    {
        NSLog(@"非文字");
        return ;
    }
    NSString* strURL = [NSString stringWithFormat:@"http://121.40.93.230/appCATM/checkDeleteTopic.php?deleteID=%lu",deleteID] ;
    // NSURL* url = [NSURL URLWithString:strURL] ;
    
    NetDownload* down = [[NetDownload alloc] init] ;
    down.delegate = self ;
    down.tag = 1002 ;
    [down downloadData:strURL] ;
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder] ;
}

#pragma mark 数据视图协议函数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* strID = @"ID" ;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strID] ;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID] ;
        cell.imageView.frame = CGRectMake(5, 5, 50, 50);
    }
    
    PictureListModel* model = [_arrayData objectAtIndex:indexPath.row] ;
    
    cell.textLabel.text= model.mTID ;
    cell.detailTextLabel.text = model.mAuthor;
    cell.imageView.image = model.mImage ;
    
    
    if (cell.isEditing) {
        // [cell bringSubviewToFront:cell.backgroundView];
    }
    
    return cell ;
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PictureListModel* pm = [_arrayData objectAtIndex:indexPath.row] ;
    
    NSURL* url = [NSURL URLWithString:@"http://121.40.93.230/appCATM/deleteTopic.php"] ;
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:url] ;
    
    request.tag = 3001 ;
    
    _curDeleteID = pm.mTID ;
    
    [request setPostValue:pm.mTID forKey:@"deleteTopicID"] ;

    [request setRequestMethod:@"POST"] ;
    
    [request buildPostBody] ;
    
    [request setDelegate:self] ;
    //开始启动连接
    [request startAsynchronous] ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 ;
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete ;
}

#pragma mark 网络下载回调函数
-(void) requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"asi start!") ;
}

-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed !");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"asi finished!") ;
    
    if (request.tag == 3001) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil] ;
        
        NSLog(@"dic = %@",dic) ;
        
        NSString* result = [dic objectForKey:@"queryOK"] ;
        
        if ([result isEqual:@"OK"])
        {
            //UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从服务器删除成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            for (int i = 0 ; i < _arrayData.count  ;i++)
            {
                PictureListModel* model =  _arrayData[i] ;
                
                //NSLog(@"MID = %@",model.mTID) ;
                if ([model.mTID isEqualToString:_curDeleteID])
                {
                    [_arrayData removeObjectAtIndex:i];
                    break ;
                }
            }
            
            [_tableView reloadData] ;
            
            _curDeleteID = @"";
        }
        else
        {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从服务器删除失败!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show] ;
        }
    }
    else
    {
        [self finishDownload:request.responseData tag:request.tag] ;
    }

}



-(void) finishImageDown:(UIImage *)image withTag:(NSUInteger)tag andID:(NSString *)strID
{
    //NSLog(@"strID = %@",strID) ;
    for (PictureListModel* model in _arrayData)
    {
        //NSLog(@"MID = %@",model.mTID) ;
        if ([model.mTID isEqualToString:strID])
        {
            model.mImage = image ;
            break ;
        }
    }
    [_tableView reloadData] ;
}





-(void) finishDownload:(NSData *)data tag:(NSUInteger)tag
{
    //更新数据
    if (tag == 1001 || tag == 1003)
    {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ;
        
        NSLog(@"dic = %@",dic) ;
        
        NSArray* arrayT = [dic objectForKey:@"topics"] ;
        
        if (arrayT.count != 0)
        {
            NSDictionary* dicTopic = [arrayT objectAtIndex:arrayT.count-1] ;
            
            NSUInteger temp = [[dicTopic objectForKey:@"id"] integerValue];
            
            if (temp == _topicLastID) {
                return;
            }
        }
        
        if (tag == 1001)
        {
            [_arrayData removeAllObjects] ;
        }
        
        for (NSDictionary* dicTopic in arrayT)
        {
            PictureListModel* pm = [[PictureListModel alloc] init] ;
            
            pm.mAuthor = [dicTopic objectForKey:@"author"] ;
            pm.mTitle = [dicTopic objectForKey:@"title"] ;
            pm.mImagePath = [dicTopic objectForKey:@"imagepath"] ;
            pm.mTID = [dicTopic objectForKey:@"id"] ;
            
            [_arrayData addObject:pm] ;
            
            NSString* strURL = [NSString stringWithFormat:@"%@%@%@",@"http://121.40.93.230/appCATM/",pm.mImagePath,@"_small"];
            
            MyImageDownload* di = [[MyImageDownload alloc] init] ;
            di.delegate = self ;
            [di downloadImage:strURL tag:[pm.mTID intValue] ID:pm.mTID];
            
            [_arrayImageDown addObject:di] ;
        }
        
        if (_arrayData.count != 0)
        {
            PictureListModel* pm = [_arrayData objectAtIndex:_arrayData.count-1];
            _topicLastID = [pm.mTID integerValue] ;
            NSLog(@"_tID = %lu",_topicLastID);
        }
        
    }
    else if (tag == 1002)
    {

        [_arrayData removeAllObjects] ;
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ;
        
        NSLog(@"dic = %@",dic) ;
        
        NSInteger count = [[dic objectForKey:@"count"] integerValue] ;
        
        if(count == 0 )
        {
            [_tableView reloadData] ;
            return ;
        }
        
        NSArray* arrayT = [dic objectForKey:@"topics"] ;
        
        for (NSDictionary* dicTopic in arrayT)
        {
            PictureListModel* pm = [[PictureListModel alloc] init] ;
            
            pm.mAuthor = [dicTopic objectForKey:@"author"] ;
            pm.mTitle = [dicTopic objectForKey:@"title"] ;
            pm.mImagePath = [dicTopic objectForKey:@"imagepath"] ;
            pm.mTID = [dicTopic objectForKey:@"id"] ;
            
            _topicLastID = [pm.mTID integerValue] ;
            
            [_arrayData addObject:pm] ;
            
            NSString* strURL = [NSString stringWithFormat:@"%@%@%@",@"http://121.40.93.230/appCATM/",pm.mImagePath,@"_small"];
            
            MyImageDownload* di = [[MyImageDownload alloc] init] ;
            di.delegate = self ;
            [di downloadImage:strURL tag:[pm.mTID intValue] ID:pm.mTID];
        }
        _tableView.frame = CGRectMake(0, 60, 320, self.view.bounds.size.height-60) ;
        [_searchBar resignFirstResponder] ;
        _searchBar.hidden = YES ;
        _tableView.tableFooterView.hidden = NO ;
    }

    [_tableView reloadData] ;
}

#pragma mark 其他
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
