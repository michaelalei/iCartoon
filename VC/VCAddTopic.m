//
//  VCAddTopic.m
//  iCartooniGame
//
//  Created by Zhu Lei on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCAddTopic.h"
#import "AppCONST.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "VCPictureList.h"

@interface VCAddTopic ()

@end

@implementation VCAddTopic

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void) firstLoadApp
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults] ;
    
    BOOL isFirst = [[ud objectForKey:FirstLoadImageVC] boolValue];
    if (isFirst) {
        isFirst = NO ;
        NSNumber* numF = [NSNumber numberWithBool:isFirst] ;
        [ud setObject:numF forKey:FirstLoadImageVC] ;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int wHeight = [UIScreen mainScreen].bounds.size.height ;
    
    _mSV = [[UIScrollView alloc] init] ;
    _mSV.frame = CGRectMake(3, 102, 314, wHeight-105) ;
    _mSV.contentSize = CGSizeMake(320, wHeight-115);
    _mSV.userInteractionEnabled = YES ;
    
    UITapGestureRecognizer* tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneSV:)] ;
    [_mSV addGestureRecognizer:tapOne] ;
    
    _mSV.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:_mSV] ;
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    
    btnBack.frame = CGRectMake(0, 20, 50, 40) ;
    [btnBack setTitle:@"返回" forState:UIControlStateNormal] ;
    [btnBack addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside] ;
    
    [self.view addSubview:btnBack] ;
    
    _btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    
    _btnSend.frame = CGRectMake(260, 20, 60, 40) ;
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal] ;
    [_btnSend addTarget:self action:@selector(pressSend) forControlEvents:UIControlEventTouchUpInside] ;
    
    [self.view addSubview:_btnSend] ;
    
    _mTFTopicTitle = [[UITextField alloc] init] ;
    _mTFTopicTitle.frame = CGRectMake(5, 55, 310, 40) ;
    _mTFTopicTitle.placeholder = @"此刻的对作品的心情,评价......";
    _mTFTopicTitle.borderStyle = UITextBorderStyleRoundedRect ;
    [self.view addSubview:_mTFTopicTitle] ;
    _mTFTopicTitle.delegate = self ;
    
    _mBtnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    
    _mBtnAdd.frame = CGRectMake(250, 200, 60, 40) ;
    [_mBtnAdd setTitle:@"添加作品" forState:UIControlStateNormal] ;
    [_mBtnAdd addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside] ;
    _mBtnAdd.hidden = YES ;
    [_mSV addSubview:_mBtnAdd] ;
    
    UIImageView* iView = [[UIImageView alloc] init] ;
    
    CGSize sizeImage  ;
    
    float fRatio = _mMainImage.size.width / 600 ;
    
    sizeImage.width = _mMainImage.size.width / fRatio ;
    sizeImage.height = _mMainImage.size.height / fRatio ;
    
    iView.frame = CGRectMake(7, 5, sizeImage.width/2, sizeImage.height/2) ;
    iView.image = _mMainImage ;
    iView.tag = 101 ;

    _mSV.backgroundColor = [UIColor blackColor] ;
    
    _mSV.contentSize = CGSizeMake(314, sizeImage.height/2+10) ;
    
    if (sizeImage.height/2+10<_mSV.frame.size.height)
    {
        _mSV.frame = CGRectMake(3, 102, 314, sizeImage.height/2+10+40) ;
        iView.frame = CGRectMake(7, 5+20, sizeImage.width/2, sizeImage.height/2) ;
    }
    [_mSV addSubview:iView] ;
    //[self saveImage:_mMainImage] ;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    _mSV.scrollEnabled = NO ;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    _mSV.scrollEnabled = YES ;
}

-(void) tapOneSV:(UIGestureRecognizer*) tapOne
{
    [_mTFTopicTitle resignFirstResponder] ;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mTFTopicTitle resignFirstResponder] ;
}

-(void) pressSend
{
    _btnSend.enabled = NO ;
    
    float wRatio = _mMainImage.size.width /640 ;
    
    CGSize sImageSize ;
    sImageSize.width  = _mMainImage.size.width / wRatio ;
    sImageSize.height = _mMainImage.size.height /wRatio ;
    
    UIImage* smallImage = [self OriginImage:_mMainImage scaleToSize:sImageSize];
    
    NSData* sData = UIImageJPEGRepresentation(smallImage, TopicSmallImageJPGScale) ;
    NSLog(@"sL = %lu",(unsigned long)sData.length) ;
    
    NSData* data = UIImageJPEGRepresentation(_mMainImage, TopicBigImageJPGScale) ;
    
    NSLog(@"normalD = %lu",(unsigned long)data.length) ;
    if (data == nil)
    {
        NSLog(@"image is Not JPG TYPE!!!");
    }
    
    NSURL* url = [NSURL URLWithString:@"http://121.40.93.230/appCATM/uploadTopic.php"] ;
    
    //for (int i = 0 ; i < 100; i++)
    {
        ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:url] ;
        
        [request setPostValue:@"佚名" forKey:@"UNAME"] ;
        //[request setPostValue:@"123456" forKey:@"password"] ;
        [request setPostValue:@"1111" forKey:@"UID"] ;
        
        [request setPostValue:_mTFTopicTitle.text forKey:@"TITLE"] ;
        [request setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)_mCategoryID] forKey:@"cateID"] ;
        
        [request setData:data withFileName:@"imageName" andContentType:@"image/jpg" forKey:@"file"] ;
        [request setData:sData withFileName:@"sImageName" andContentType:@"image/jpg" forKey:@"file02"];
        
        [request setRequestMethod:@"POST"] ;
        
        [request buildPostBody] ;
        
        if (_mPC )
        {
            [_mPC.arrayRequest addObject:request] ;
        }

        [request setDelegate:self] ;
        //开始启动连接
        [request startAsynchronous] ;
    }

}

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
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil] ;
    
    NSLog(@"dic = %@",dic) ;
    
    if (_mPC )
    {
        //VCPictureList* pc = (VCPictureList*)self.parentViewController ;
        
        [_mPC loadDataFromServer] ;
    }
    
    _btnSend.enabled = YES ;
    //可以在此做数据缓存
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(NSString*) getDocImagePath
{
    NSString* strPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/image/"] ;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil] ;
    
    return strPath ;
}

-(NSString*) getSaveFullFileName:(NSString*) fileName
{
    NSString* strFullPath = [[self getDocImagePath] stringByAppendingString:fileName] ;
    
    return strFullPath ;
}

-(NSString*) getSaveFullFileNameSmall:(NSString*) fileName
{
    NSString* strFullPath = [[self getDocImagePath] stringByAppendingFormat:@"%@%@",fileName,@"_s"] ;
    
    return strFullPath ;
}

-(void) pressAdd
{
    
}

-(void) saveImage:(UIImage*) img
{
    CGSize size = img.size ;
    
    CGFloat ratio = 0 ;
    
    if (size.width*480.0/320.0 > size.height)
    {
        ratio = 320.0/size.width;
    }
    else
    {
        ratio = 480.0/size.height ;
    }
    
    CGRect rect = CGRectMake(3, 0, ratio*size.width-6, ratio*size.height) ;
    UIImageView* iView = (UIImageView*)[self.view viewWithTag:101];
    iView.frame = rect ;
    iView.image = img ;
    
    _mBtnAdd.frame = CGRectMake(250, rect.origin.y+rect.size.height+20, 60, 40);
    
    _mSV.contentSize = CGSizeMake(320, _mBtnAdd.frame.origin.y+60) ;
    return ;
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


-(void) pressBack
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
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
