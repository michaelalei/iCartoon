//
//  VCPictureTopicScrollShow.m
//  iCartooniGame
//
//  Created by Zhu Lei on 14-8-2.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCPictureTopicScrollShow.h"

@interface VCPictureTopicScrollShow ()

@end

@implementation VCPictureTopicScrollShow

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO ;
    self.tabBarController.tabBar.translucent = NO ;
    _arrayData = [[NSMutableArray alloc] init] ;
    
    for (int i = 0 ; i < 10; i++) {
        [_arrayData addObject:@"ttt"] ;
    }
    
    _mSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, self.view.bounds.size.height-60)];
    
    _mSV.contentSize = CGSizeMake(320*_arrayData.count, self.view.bounds.size.height-60) ;
    
    _mSV.pagingEnabled = YES ;
    
    _mSV.bounces = NO ;
    
    for (int i = 0 ; i < _arrayData.count; i++)
    {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"study_image%d.png",i%6+1]] ;
        
        UIImageView* iView = [[UIImageView alloc] initWithImage:image] ;
        
        iView.frame = CGRectMake(320*i, 0, 320, self.view.bounds.size.height-60) ;
        
        iView.backgroundColor = [UIColor blackColor];
        
        [_mSV addSubview:iView] ;
    }
    
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btnBack.frame = CGRectMake(0, 20, 60, 40) ;
    [btnBack setTitle:@"返回" forState:UIControlStateNormal] ;
    [btnBack setTitleColor:[UIColor colorWithRed:0.3 green:0.4 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside] ;
    [btnBack setTintColor:[UIColor lightGrayColor]];
    //[_mSV addSubview:btnBack] ;
    _mSV.userInteractionEnabled = YES ;
    
    [self.view addSubview:_mSV] ;
    [self.view addSubview:btnBack] ;

}

-(void) pressBack
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES ;

}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO ;
    self.tabBarController.tabBar.translucent = YES ;
    //[self.navigationController.tabBarController setHidesBottomBarWhenPushed:NO];
}
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
