//
//  VCPictureList.m
//  iCartooniGame
//
//  Created by Zhu Lei on 14-7-31.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCPictureList.h"
#import "PictureListCell.h"
#import "VCPictureTopicScrollShow.h"
#import "VCTopicPictureComment.h"
#import "VCAddTopic.h"
#import "PictureListModel.h"
#import "MyImageDownload.h"
#import "AppDelegate.h"
#import "AppCONST.h"
#import "VCLogin.h"
#import "VCDeleteTopic.h"
#import "ASIHTTPRequest.h"
#import "VCShowSingleImage.h"
#import "VCPostWarn.h"
#import "Reachability.h"
#import "ASIDownloadCache.h"
#import "CDManager.h"

#define NUMBER_OF_TOPIC_ONCE_UPDATE 5

@interface VCPictureList ()

@end

@implementation VCPictureList

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)  refreshUI
{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) animated:NO] ;
    
    //[_arrayData removeAllObjects] ;
    //[_tableView reloadData] ;
}

-(void) setCategoryID:(NSUInteger)categoryID
{
    if (_categoryID != categoryID)
    {
        _mIsNeedUpdate = YES;
        _categoryID = categoryID ;
    }
    else if (_arrayData.count != 0)
    {
        _mIsNeedUpdate = NO ;
    }
}

-(void) loadData
{
    
//    [_arrayData removeAllObjects] ;
//    CDManager* cdm = [CDManager getSingleton] ;
////
//    [cdm.managedObjectContext deletedObjects] ;
    

    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kNotReachable)
    {
        [_arrayData removeAllObjects] ;
        CDManager* cdm = [CDManager getSingleton] ;
        
        NSArray* arrayTopicModel = [cdm fetchTopicModelByCat:[NSString stringWithFormat:@"%ld",self.categoryID]] ;
        
        [_arrayData addObjectsFromArray:arrayTopicModel] ;
        
        for (PictureListModel* pm in _arrayData)
        {
            NSString* strURL = [NSString stringWithFormat:@"%@%@%@",@"http://121.40.93.230/appCATM/",pm.mImagePath,@"_small"];
            
            MyImageDownload* di = [[MyImageDownload alloc] init] ;
            di.delegate = self ;
            [di downloadImage:strURL tag:[pm.mTID intValue] ID:pm.mTID];
            
            [_arrayImageDownload addObject:di] ;
        }
        
        if (arrayTopicModel.count < NUMBER_OF_TOPIC_ONCE_UPDATE)
        {
            UILabel* label = (UILabel*)_tableView.tableFooterView ;
            label.text = @"暂无更多内容";
            label.textColor = [UIColor darkGrayColor];
        }
        else{
            UILabel* label = (UILabel*)_tableView.tableFooterView ;
            label.text = @"更多内容";
            label.textColor = [UIColor purpleColor];
        }
        
        [_tableView reloadData] ;
    }
    else
    {
        [self loadDataFromServer] ;
    }
}

-(void) loadDataFromServer
{
    
    NSString* strURL = [NSString stringWithFormat:@"http://121.40.93.230/appCATM/getLatestTopics.php?cat=%lu&number=%d",(unsigned long)_categoryID,NUMBER_OF_TOPIC_ONCE_UPDATE] ;

    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    [request setDownloadCache:self.myCache];
    
    //[request setRequestMethod:@"GET"] ;
    
    request.delegate = self ;
    
    request.tag = 1001 ;
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [request startAsynchronous] ;
    
    [_arrayNetDownlaod addObject:request] ;
}

-(void) requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"s request!");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    [self finishDownload:request.responseData tag:request.tag] ;
}

-(void) loadDataFromServerNoASI
{
    NSString* strURL = [NSString stringWithFormat:@"http://121.40.93.230/appCATM/getLatestTopics.php?cat=%lu&number=10",(unsigned long)_categoryID] ;
   // NSURL* url = [NSURL URLWithString:strURL] ;
    
    NetDownload* down = [[NetDownload alloc] init] ;
    down.delegate = self ;
    down.tag = 1001 ;
    [down downloadData:strURL] ;
    
    //[_arrayNetDownlaod addObject:down] ;
}


-(void) addConnect:(NSURLConnection *)connect
{
    [_arrayDelegateConnect addObject:connect] ;
}


-(void) finishDownload:(NSData *)data tag:(NSUInteger)tag
{

    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ;
    
    NSLog(@"dic = %@",dic) ;
    
    NSArray* arrayT = [dic objectForKey:@"topics"] ;
    
    if (arrayT.count != 0)
    {
        NSDictionary* dicTopic = [arrayT objectAtIndex:0] ;
        
        NSUInteger temp = [[dicTopic objectForKey:@"id"] integerValue];
        
//        if (temp == _topicLastID) {
//            return;
//        }
    }

//    if (_arrayData.count != 0) {
//        return ;
//    }
    //更新数据
    if (tag == 1001)
    {
        [_arrayData removeAllObjects] ;
    }
    
    
    for (NSDictionary* dicTopic in arrayT)
    {
        CDManager* cdm = [CDManager getSingleton] ;
        
        NSString* tid = [dicTopic objectForKey:@"id"] ;
        BOOL isHaveTopicInCD = [PictureListModel isHaveTopic:tid] ;
        PictureListModel* pm2 = (PictureListModel*)[PictureListModel getTopicByID:tid] ;
        
        if (isHaveTopicInCD  == YES)
        {
            [_arrayData addObject:pm2] ;
            
            MyImageDownload* di = [[MyImageDownload alloc] init] ;
            di.delegate = self ;
            
            NSString* strURL = [NSString stringWithFormat:@"%@%@%@",@"http://121.40.93.230/appCATM/",pm2.mImagePath,@"_small"];
            [di downloadImage:strURL tag:[pm2.mTID intValue] ID:pm2.mTID];
            
            [_arrayImageDownload addObject:di] ;
            continue ;
        }
        else
        {
            PictureListModel* pm = [NSEntityDescription insertNewObjectForEntityForName:@"PictureListModel"
                                                                 inManagedObjectContext:cdm.managedObjectContext]; ;
            
            pm.mAuthor = [dicTopic objectForKey:@"author"] ;
            pm.mTitle = [dicTopic objectForKey:@"title"] ;
            pm.mImagePath = [dicTopic objectForKey:@"imagepath"] ;
            pm.mTID = [dicTopic objectForKey:@"id"] ;
            pm.mIsFirstShowImage = [NSNumber numberWithBool:YES] ;
            pm.mCatID = [dicTopic objectForKey:@"catID"];
            NSLog(@"catID = %@",pm.mCatID) ;
            
            NSString* strURL = [NSString stringWithFormat:@"%@%@%@",@"http://121.40.93.230/appCATM/",pm.mImagePath,@"_small"];
            
            [_arrayData addObject:pm] ;
            
            MyImageDownload* di = [[MyImageDownload alloc] init] ;
            di.delegate = self ;
            [di downloadImage:strURL tag:[pm.mTID intValue] ID:pm.mTID];
            
            [_arrayImageDownload addObject:di] ;
            
           // if (isHaveTopicInCD == NO) {
                [pm saveToCD] ;
                
           // }
//            else
//            {
//                [cdm.managedObjectContext deleteObject:pm];
//            }
        }
        

    }
    [_tableView reloadData] ;
    if (arrayT.count < NUMBER_OF_TOPIC_ONCE_UPDATE)
    {
        UILabel* label = (UILabel*)_tableView.tableFooterView ;
        label.text = @"暂无更多内容";
        label.textColor = [UIColor darkGrayColor];
    }
    else{
        UILabel* label = (UILabel*)_tableView.tableFooterView ;
        label.text = @"更多内容";
        label.textColor = [UIColor purpleColor];
    }

    
    if (_arrayData.count != 0)
    {
        PictureListModel* pm = [_arrayData objectAtIndex:_arrayData.count-1];
        _topicLastID = [pm.mTID integerValue] ;
    }
    
    [_tableView reloadData] ;
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
            //model.mIsFirstShowImage = YES ;
            break ;
        }
    }
    [_tableView reloadData] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO ;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain] ;
    
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
   // _tableView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_tableView] ;
    
    UILabel* labelUpdate = [[UILabel alloc] init] ;
    labelUpdate.frame = CGRectMake(0, 0, 320, 100) ;
    labelUpdate.userInteractionEnabled = YES ;
    labelUpdate.textAlignment = NSTextAlignmentCenter ;
    labelUpdate.font = [UIFont systemFontOfSize:15];
    labelUpdate.text= @"更多内容";
    labelUpdate.textColor = [UIColor purpleColor] ;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMore:)] ;
    
    [labelUpdate addGestureRecognizer:tap] ;

    _tableView.tableFooterView  = labelUpdate ;

    
    _arrayData = [[NSMutableArray alloc] init] ;
    _arrayRequest = [[NSMutableArray alloc] init] ;
    _arrayDelegateConnect = [[NSMutableArray alloc] init] ;
    _arrayNetDownlaod = [[NSMutableArray alloc] init] ;
    _arrayImageDownload = [[NSMutableArray alloc] init] ;
    
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    self.myCache = cache;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [self.myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    [self.myCache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    //[self.myCache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    _mIsNeedUpdate = YES ;
}

-(void) dealloc
{
    
    //取消所有下载操作
//    for (ASIHTTPRequest* request in _arrayRequest)
//    {
//        [request cancel] ;
//    }
//    for (NSURLConnection* connect in _arrayDelegateConnect) {
//        [connect cancel] ;
//    }
    
    for (MyImageDownload* imageD in _arrayImageDownload) {
        
        imageD.delegate = nil ;
    }
    
    for (ASIHTTPRequest* down in _arrayNetDownlaod) {
        [down cancel] ;
        down.delegate = nil ;
    }
}

-(void) pressDelete
{
    VCDeleteTopic* dTopic = [[VCDeleteTopic alloc] init] ;
    
    [self presentViewController:dTopic animated:YES completion:nil] ;

}

-(void) tapMore:(UITapGestureRecognizer*) tap
{
    NSLog(@"more ...");
    NSString* strURL = [NSString stringWithFormat:@"http://121.40.93.230/appCATM/getMoreTopic.php?cat=%lu&number=30&startID=%lu",(unsigned long)_categoryID,(unsigned long)_topicLastID] ;
    
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    [request setRequestMethod:@"GET"] ;
    
    request.delegate = self ;
    
    request.tag = 1002 ;
    
    [request setCachePolicy:ASIUseDefaultCachePolicy] ;
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    
    [request startAsynchronous] ;
    
    [_arrayNetDownlaod addObject:request] ;
    
    // NSURL* url = [NSURL URLWithString:strURL] ;
    
//    NetDownload* down = [[NetDownload alloc] init] ;
//    down.delegate = self ;
//    //获取更多数据
//    down.tag = 1002 ;
//    [down downloadData:strURL] ;
}


-(void) pressUpdate
{
    NSLog(@"press 更新！");
    //[self loadDataFromServer] ;
}

-(void) pressAddAct
{
    AppDelegate* de = GetAppDelegate() ;
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults] ;
    
    BOOL isUnFirst = [[ud objectForKey:@"isFirstPostTopic"] boolValue];
    
    if (isUnFirst == FALSE) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您即将发布的信息将被显示在动漫社区的公共平台上,请遵守AppStore规则及国家的法律法规.\n感谢您的合作!\n选择同意表示您将遵守以上规则.\n" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"同意", nil] ;
        [alert show] ;
        alert.delegate = self ;
        alert.tag = 1001;

        [ud setObject:[NSNumber numberWithBool:isUnFirst] forKey:@"isFirstPostTopic"];

    }
    else
    {
        if (de.isLogin == YES)
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //picker.allowsEditing=YES;
            picker.delegate =self;
            //picker.allowsImageEditing = YES ;
            [self presentViewController:picker animated:YES completion:nil] ;
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布作品需要登录.\n亲,需要现在登录吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil] ;
            [alert show] ;
            alert.delegate = self ;
        }
    }

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
        if (buttonIndex == 0) {
            return ;
        }
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults] ;

        [ud setObject:[NSNumber numberWithBool:TRUE] forKey:@"isFirstPostTopic"];
        
        AppDelegate* de = GetAppDelegate() ;
        if (de.isLogin == YES)
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //picker.allowsEditing=YES;
            picker.delegate =self;
            //picker.allowsImageEditing = YES ;
            [self presentViewController:picker animated:YES completion:nil] ;
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布作品需要登录.\n亲,需要现在登录吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil] ;
            [alert show] ;
            alert.delegate = self ;
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            VCLogin* login = [[VCLogin alloc] init] ;
            
            [self presentViewController:login animated:YES completion:nil] ;
        }
    }

}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayData count] ;
}

-(void) pressCellReport:(UIButton*) btn
{
    VCPostWarn* vc = [[VCPostWarn alloc] init] ;
    
    UITableViewCell* cell = (UITableViewCell*)(btn.superview.superview.superview) ;
    
    NSIndexPath* path = [_tableView indexPathForCell:cell] ;
    
    NSLog(@"index = %ld",path.row) ;
    PictureListModel* model = [_arrayData objectAtIndex:path.row] ;
    
    vc.mImage = model.mImage ;
    vc.mLBTitle.text = model.mTitle;
   // cell.mLBTitle.text = model.mTitle ;
    vc.mTopicID = model.mTID ;

    [self presentViewController:vc animated:YES completion:nil] ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strID = @"PictureListCell" ;
    
    PictureListCell* cell = [tableView dequeueReusableCellWithIdentifier:strID] ;
    if (cell== nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureListCell" owner:self options:nil] lastObject];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer* tapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentView:)] ;
        
        cell.mLBComment.userInteractionEnabled = YES ;
        [cell.mLBComment addGestureRecognizer:tapComment] ;
        
        [cell.mLBReport addTarget:self action:@selector(pressCellReport:) forControlEvents:UIControlEventTouchUpInside] ;
        
        UITapGestureRecognizer* tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)] ;
        
        cell.mMainImage.userInteractionEnabled = YES ;
        [cell.mMainImage addGestureRecognizer:tapImageView] ;
        //cell.mMainImage.layer.cornerRadius = 40 ;
        //cell.textLabel.textAlignment = NSTextAlignmentCenter ;
    }
    
    
    PictureListModel* model = [_arrayData objectAtIndex:indexPath.row] ;
    
    cell.mLBAuthor.text = model.mAuthor ;
    cell.mLBComment.text = @"暂无评论";
    cell.mLBTitle.text = model.mTitle ;
    
    if (indexPath.row == 0)
    {
        NSLog(@"SIw = %f",model.mImage.size.width) ;
        NSLog(@"SIh = %f",model.mImage.size.height) ;
    }

    cell.mMainImage.frame = CGRectMake(10, 50, 300, model.mImage.size.height/2*300/320) ;
    
    
    if (model.mImage != nil)
    {
//        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults] ;
//        
//        NSNumber* num  = [ud objectForKey:model.mTID];
//        BOOL isFirstLoad = [num boolValue] ;
//        
//        NSLog(@"num = %d uid = %@",isFirstLoad,model.mTID);
        
        cell.mMainImage.image = model.mImage ;
//        if (isFirstLoad == NO)
//        {
//            [ud setObject:[NSNumber numberWithBool:YES] forKey:model.mTID] ;
//            cell.mMainImage.alpha = 0 ;
//            [UIView animateWithDuration:0.9 animations:^
//             {
//                 cell.mMainImage.alpha = 1 ;
//             }];
//        }
    }
    

    return cell ;
}

-(void) tapCommentView:(UITapGestureRecognizer*) tap
{
    return ;
    
    if ([tap.view.superview.superview isKindOfClass:[PictureListCell class]]) {
        
        PictureListCell* cell = (PictureListCell*) tap.view.superview.superview ;
        
        VCTopicPictureComment* vc = [[VCTopicPictureComment alloc] init] ;
        vc.mMainImage =  cell.mMainImage.image ;
        [self.navigationController pushViewController:vc animated:YES] ;
        
    }

}

-(void) tapImageView:(UITapGestureRecognizer*) tap
{
    return ;
    PictureListCell* cell = (PictureListCell*) tap.view.superview ;
    
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell] ;
    
    PictureListModel* pm = [_arrayData objectAtIndex:indexPath.row] ;
    
    VCShowSingleImage* sv = [[VCShowSingleImage alloc] init] ;
    
    sv.mImagePath = pm.mImagePath ;
    
    //VCPictureTopicScrollShow* picVC = [[VCPictureTopicScrollShow alloc] init] ;
    
    [self.navigationController pushViewController:sv animated:YES] ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PictureListModel* model = [_arrayData objectAtIndex:indexPath.row] ;
    return  100 + model.mImage.size.height/2*300/320;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //VCTopicPictureComment* vc = [[VCTopicPictureComment alloc] init] ;
    
    //[self.navigationController pushViewController:vc animated:YES] ;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
    
    if (image.size.width < 640)
    {
        UIAlertView* alv = [[UIAlertView alloc] initWithTitle:@"错误" message:@"为保证图像质量,上传图像尺寸宽度要高于640!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] ;
        
        [alv show] ;
        
        return ;
    }
    
    NSLog(@"imageWidth = %f",image.size.width) ;
    
    [picker dismissViewControllerAnimated:NO completion:^
     {
         _vcAddTopic = [[VCAddTopic alloc] init] ;
         _vcAddTopic.mMainImage = image ;
         _vcAddTopic.mPC = self ;
         _vcAddTopic.mCategoryID = _categoryID ;
         [self presentViewController:_vcAddTopic animated:YES completion:nil] ;
     }] ;
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO ;
}

-(void) viewWillAppear:(BOOL)animated
{
    if (_mIsNeedUpdate == YES)
    {
        [self loadData] ;
        _mIsNeedUpdate = NO ;
    }
    
    UIBarButtonItem* barAddItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAddAct)] ;
    
    UIBarButtonItem* barUpdateItem =[[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(pressUpdate)] ;
    _barDeleteItem =[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(pressDelete)] ;
    
    NSArray* array = nil ;
    
    AppDelegate* de = GetAppDelegate() ;
    
    if (de.isMaster == NO)
    {
        if (_categoryID == 0)
        {
            array  = [NSArray arrayWithObjects:barUpdateItem, nil] ;
        }
        else
        {
            array  = [NSArray arrayWithObjects:barAddItem,barUpdateItem, nil] ;
        }
    }
    else
    {
        array  = [NSArray arrayWithObjects:barUpdateItem,_barDeleteItem, nil] ;
    }
    
    self.navigationItem.rightBarButtonItems = array ;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

//-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
//}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    static float lastOffsetY = 0 ;
    //NSLog(@"offset = %f, h = %f",scrollView.contentOffset.y,scrollView.contentSize.height);
    if (scrollView.contentSize.height < 100) {
        return ;
    }
    if (scrollView.contentOffset.y > scrollView.contentSize.height-600) {
        self.tabBarController.tabBar.hidden = YES ;
        lastOffsetY = scrollView.contentOffset.y ;
        return ;
    }
    if (scrollView.contentOffset.y < 100) {
        self.tabBarController.tabBar.hidden = NO ;
        lastOffsetY = scrollView.contentOffset.y ;
        return ;
    }
    //return ;
    BOOL isUp = YES ;
    if (scrollView.contentOffset.y > lastOffsetY)
    {
        isUp = YES ;
        self.tabBarController.tabBar.hidden = YES ;
    }
    else if (scrollView.contentOffset.y < lastOffsetY)
    {
        isUp = NO ;
        self.tabBarController.tabBar.hidden = NO ;
    }
    lastOffsetY = scrollView.contentOffset.y ;
    
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
