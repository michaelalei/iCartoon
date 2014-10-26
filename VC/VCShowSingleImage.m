//
//  VCShowSingleImage.m
//  iCartooniGame
//
//  Created by qianfeng on 14-9-19.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCShowSingleImage.h"
#import "MyImageDownload.h"

@implementation VCShowSingleImage

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
    self.view.backgroundColor = [UIColor blackColor] ;
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO ;

    _imageView = [[UIImageView alloc] init] ;
    _imageView.backgroundColor = [UIColor blackColor] ;
    
    _watingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
    
    _imageView.userInteractionEnabled = YES ;
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAct:)] ;
    [_imageView addGestureRecognizer:pinch] ;
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAct:)] ;
    
    [_imageView addGestureRecognizer:pan] ;
    
    [self.view addSubview:_watingView] ;
    [self.view addSubview:_imageView] ;

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 60, 40)] ;
    
    view.backgroundColor = [UIColor blueColor] ;
    
    UITapGestureRecognizer* tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActBack:)] ;
    
    tapOne.numberOfTapsRequired = 1 ;
    
    [view addGestureRecognizer:tapOne] ;
    
    [self.view addSubview:view] ;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct:)] ;
    
    tap.numberOfTapsRequired = 2 ;
    
    [self.view addGestureRecognizer:tap] ;
}

//-(void) pressBack
//{
//    [self.navigationController popViewControllerAnimated:YES] ;
//}

-(void) tapActBack:(UITapGestureRecognizer*) tap
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

-(void) tapAct:(UITapGestureRecognizer*) tap
{
    [UIView animateWithDuration:1 animations:^
    {
            float height = _imageView.image.size.height/(_imageView.image.size.width / 310 );
        
            _imageView.frame = CGRectMake(5, (self.view.bounds.size.height-height)/2, 310, height) ;
    }];
}
-(void) addConnect:(NSURLConnection *)connect
{
    
}

-(void) pinchAct:(UIPinchGestureRecognizer*) pinch
{
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform,pinch.scale,pinch.scale) ;
    
    pinch.scale = 1 ;
}

-(void) panAct:(UIPanGestureRecognizer*) pan
{
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        _beginPT = [pan locationInView:self.view] ;
    }
    else
    {
        CGPoint pt = [pan locationInView:self.view] ;
        CGPoint pOff ;
        pOff.x = pt.x - _beginPT.x ;
        pOff.y = pt.y - _beginPT.y ;
        
        pan.view.frame = CGRectMake(pan.view.frame.origin.x + pOff.x, pan.view.frame.origin.y + pOff.y, pan.view.frame.size.width, pan.view.frame.size.height);
        
        _beginPT = pt ;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = YES ;
    self.navigationController.tabBarController.tabBar.hidden = YES ;
    [_watingView startAnimating] ;
    
    NSString* strURL = [NSString stringWithFormat:@"%@%@",@"http://121.40.93.230/appCATM/",_mImagePath];
    
    MyImageDownload* imageDown = [[MyImageDownload alloc] init];
    imageDown.delegate = self ;
    
    [imageDown downloadImage:strURL tag:101 ID:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO ;
    self.navigationController.tabBarController.tabBar.hidden = NO ;
}

-(void) finishImageDown:(UIImage *)image withTag:(NSUInteger)tag andID:(NSString*) strID
{
    
    [_watingView stopAnimating] ;
    
    float height = image.size.height/(image.size.width / 310 );
    
    _imageView.frame = CGRectMake(5, (self.view.bounds.size.height-height)/2, 310, height) ;
    
    _imageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
