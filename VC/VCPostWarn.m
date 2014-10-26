//
//  VCPostWarn.m
//  iCartooniGame
//
//  Created by qianfeng on 14-9-27.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCPostWarn.h"

@interface VCPostWarn ()

@end

@implementation VCPostWarn

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
    // Do any additional setup after loading the view from its nib.
    
    self.mMainImage.image = self.mImage ;
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
    NSLog(@"finished");
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
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mTVContent resignFirstResponder] ;
}

- (IBAction)pressWarn:(id)sender
{
    
    NSURL* url = [NSURL URLWithString:@"http://121.40.93.230/appCATM/reportBadTopic.php"] ;
    
    //for (int i = 0 ; i < 100; i++)
    {
        ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:url] ;
        
        [request setPostValue:self.mTopicID forKey:@"UID"] ;

        [request setRequestMethod:@"POST"] ;
        
        [request buildPostBody] ;
        
        [request setDelegate:self] ;
        //开始启动连接
        [request startAsynchronous] ;
    }
    
    //上传服务器
    NSLog(@"举报内容！！！");
}
- (IBAction)pressBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil] ;
}
@end
