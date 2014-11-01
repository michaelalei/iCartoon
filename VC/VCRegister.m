//
//  VCRegister.m
//  iCartoom爱动漫
//
//  Created by qianfeng on 14-9-15.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "VCRegister.h"
#import "AppDelegate.h"
#import "AppCONST.h"
#import "Reachability.h"

#define RegisterURL @"http://121.40.93.230/appCATM/register.php?userName=%@&password=%@"

@interface VCRegister ()

@end

@implementation VCRegister

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
    _isOK = NO ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) checkNetworkIsOK
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kNotReachable)
    {
        UIAlertView* alv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的网络好像有点问题哦!\n请确认网络正常后再试." delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        
        [alv show] ;
        
        return NO ;
    }
    return YES ;
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

- (IBAction)pressRegister:(id)sender {
    
    if ([self checkNetworkIsOK] == NO) {
        return ;
    }
    
    NSString* uName = _mTFUesrName.text ;
    NSString* password = _mTFPassword.text ;
    NSString* passwordComfirm = _mTFPasswordComfirm.text ;
    
    if (![password isEqualToString:passwordComfirm ])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不统一\n请确认输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        [alert show] ;
        return ;
    }
    
    if (_mTFUesrName.text.length == 0 || _mTFPassword.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        [alert show] ;
        
        return ;
    }
    
    NSLog(@"uName = %@",uName) ;
    NSLog(@"pW = %@",password) ;
    NSLog(@"pConfirm = %@",passwordComfirm) ;
    //??????
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:RegisterURL,_mTFUesrName.text,_mTFPassword.text]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url] ;
    
    NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self] ;
    
    [connect start] ;
    //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateData:) userInfo:nil repeats:NO];
    
    _waitAIV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 140, 40, 40)] ;
    [_waitAIV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray] ;
    [_waitAIV startAnimating] ;
    _waitAIV.tag = 101 ;
    
    [self.view addSubview:_waitAIV] ;
    
    {
        _data = [[NSMutableData alloc] init] ;
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response = %@",response) ;
   
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data] ;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil] ;
    
    NSLog(@"dic = %@",dic);
    
    [_waitAIV stopAnimating] ;
    [_waitAIV removeFromSuperview] ;
    //NSString* strError = [dic objectForKey:@"ErrCode"] ;
    int result = [[dic objectForKey:@"status"] intValue];
    if (result == 1)
    {
        _isOK = YES ;
    
        AppDelegate* de = GetAppDelegate() ;
        de.isLogin = YES ;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功!\n并且成功登录!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        [alert show] ;
        alert.delegate = self ;
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        [alert show] ;
    }
//    if (rValue == 0 )
//    {
//        NSLog(@"Register Success!");
//    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"请求失败 error = %@", error);
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_isOK == YES)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [_vcLogin dismissViewControllerAnimated:YES completion:nil] ;
        }] ;
    }
}


- (IBAction)pressBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mTFPassword resignFirstResponder] ;
    [_mTFPasswordComfirm resignFirstResponder] ;
    [_mTFUesrName resignFirstResponder] ;
}
@end
