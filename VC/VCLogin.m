//
//  VCLogin.m
//  iCartoom爱动漫
//
//  Created by qianfeng on 14-9-15.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "VCLogin.h"
#import "VCRegister.h"
#import "AppCONST.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"

#define LoginURL @"http://121.40.93.230/appCATM/login.php?userName=%@&password=%@"


@interface VCLogin ()

@end

@implementation VCLogin

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}

-(void) test
{
    
}

-(void) checkPass:(CheckBox*) checkBT
{
    _isRecondPassword = checkBT.on ;
    NSLog(@"pass = %d",checkBT.on) ;
}

-(void) checkUName:(CheckBox*) checkBT
{
    _isRecondUsername = checkBT.on ;
    NSLog(@"uName = %d",checkBT.on) ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_mCBPassword addTarget:self
                     action:@selector(checkPass:) forControlEvents:UIControlEventValueChanged] ;
    
    [_mCBUserName addTarget:self action:@selector(checkUName:) forControlEvents:UIControlEventValueChanged] ;
    
    _isRecondPassword = NO ;
    _isRecondUsername = NO ;
}

-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    _isRecondUsername = [[ud objectForKey:@"isRecondUsername"] boolValue];
    _isRecondPassword = [[ud objectForKey:@"isRecondPassword"] boolValue] ;
    
    [_mCBPassword setOn:_isRecondPassword] ;
    [_mCBUserName setOn:_isRecondUsername] ;
    if (_isRecondUsername) {
        _mTFUserName.text = [ud objectForKey:@"userName"] ;
    }
    if (_isRecondPassword)
    {
        _mTFPassword.text = [ud objectForKey:@"password"] ;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:[NSNumber numberWithBool:_isRecondUsername] forKey:@"isRecondUsername"] ;
    
    [ud setObject:[NSNumber numberWithBool:_isRecondPassword] forKey:@"isRecondPassword"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pressLogin:(id)sender
{
    
    if (_mTFUserName.text.length == 0 || _mTFPassword.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        [alert show] ;
        
        return ;
    }
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:_mTFUserName.text forKey:@"userName"] ;
    [ud setObject:_mTFPassword.text forKey:@"password"] ;
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:LoginURL,_mTFUserName.text,_mTFPassword.text]];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    
    NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self] ;
    
    [connect start] ;
    
    _data = [[NSMutableData alloc] init] ;
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data] ;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil] ;
    
    NSLog(@"dic = %@",dic);
    
    //NSString* strError = [dic objectForKey:@"ErrCode"] ;
    int result = [[dic objectForKey:@"LoginStatus"] intValue];
    int userState = [[dic objectForKey:@"UserStatus"] intValue] ;
    
    if (userState == 0) {
        NSLog(@"普通用户!");
    }
    else if (userState >= 1 && userState <= 100 )
    {
        NSLog(@"问题用户!");
    }
    else if(userState == 888)
    {
        NSLog(@"管理员用户!");
    }
    if (result == 1)
    {
        _isOK = YES ;
        AppDelegate* de = GetAppDelegate() ;
        de.isLogin = YES ;
        NSString* str =@"登录成功!";
        de.isMaster = NO ;
        if (userState == 888)
        {
            de.isMaster = YES ;
            str = @"管理员账号登录成功!" ;
        }
        if (userState >= 1 && userState <= 100 )
        {
            str = @"您当前的状态为禁止发言状态,\n服务器拒绝您的登录,\n请遵守此app内容规范,\n稍后再试!";
            de.isLogin = NO ;
        }

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        [alert show] ;
        alert.delegate = self ;
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败\n账号或秘密错误!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] ;
        [alert show] ;
    }
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_isOK == YES)
    {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }
}


- (IBAction)pressRegister:(id)sender {
    VCRegister* rVC = [[VCRegister alloc] init] ;
    rVC.vcLogin = self ;
    [self presentViewController:rVC animated:YES completion:nil] ;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mTFPassword resignFirstResponder] ;
    [_mTFUserName resignFirstResponder] ;
}
- (IBAction)pressBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

@end
