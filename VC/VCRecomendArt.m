//
//  VCRecomendArt.m
//  iCartooniGame
//
//  Created by Zhu Lei on 14-7-31.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCRecomendArt.h"
//#import "PictureListCell.h"
#import "RecomendArtCell.h"
#import "VCPictureTopicScrollShow.h"
#import "VCTopicPictureComment.h"
#import "VCAddTopic.h"

@interface VCRecomendArt ()

@end

@implementation VCRecomendArt

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = @"达人作品" ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.extendedLayoutIncludesOpaqueBars = NO ;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-110) style:UITableViewStylePlain] ;
    
    _tableView.delegate = self ;
    _tableView.dataSource = self ;

    [self.view addSubview:_tableView] ;
    _tableView.backgroundColor = [UIColor lightGrayColor];
    
    //此版本暂时屏蔽达人发帖功能
    //UIBarButtonItem* barAddItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAddAct)] ;
    
    //self.navigationItem.rightBarButtonItem = barAddItem ;
    
    _arrayData = [[NSMutableArray alloc] init] ;
    
    for (int i = 0 ; i < 10 ; i++)
    {
        [_arrayData addObject:[NSString stringWithFormat:@"data %d",i]] ;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO ;
    self.tabBarController.tabBar.translucent = NO ;
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES ;
    self.tabBarController.tabBar.translucent = YES ;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//[_arrayData count] ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strID = @"PictureListCell" ;
    
    RecomendArtCell* cell = [tableView dequeueReusableCellWithIdentifier:strID] ;
    if (cell== nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecomendArtCell" owner:self options:nil] lastObject];
        
//        
//        UITapGestureRecognizer* tapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentView:)] ;
//        
//        
//        [cell.mCommentView addGestureRecognizer:tapComment] ;
//        
        UITapGestureRecognizer* tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)] ;
        
        cell.mMainImage.userInteractionEnabled = YES ;
        [cell.mMainImage addGestureRecognizer:tapImageView] ;
        
        //cell.textLabel.textAlignment = NSTextAlignmentCenter ;
    }
    
    //NSDictionary* dic = [_arrayData objectAtIndex:indexPath.section] ;
    //NSArray* arrayD = [dic objectForKey:@"data"] ;
    
    //cell.textLabel.text = [arrayD objectAtIndex:indexPath.row] ;
    
    return cell ;
}

-(void) tapCommentView:(UITapGestureRecognizer*) tap
{
    VCTopicPictureComment* vc = [[VCTopicPictureComment alloc] init] ;
    
    [self.navigationController pushViewController:vc animated:YES] ;
}

-(void) tapImageView:(UITapGestureRecognizer*) tap
{
    VCPictureTopicScrollShow* picVC = [[VCPictureTopicScrollShow alloc] init] ;
    
    [self.navigationController pushViewController:picVC animated:YES] ;
}

//改变cell北京颜色
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  420 ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一版点击进入图像观赏功能,以后开放为评论界面
//    
//    VCTopicPictureComment* vc = [[VCTopicPictureComment alloc] init] ;
//    
//    [self.navigationController pushViewController:vc animated:YES] ;
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
