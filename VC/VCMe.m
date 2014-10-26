//
//  VCMe.m
//  iCartooniGame
//
//  Created by Zhu Lei on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCMe.h"
#import "VCLogin.h"
#import "AppDelegate.h"
#import "AppCONST.h"

@interface VCMe ()

@end

@implementation VCMe

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = @"我的";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped] ;
    
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    
    [self.view addSubview:_tableView] ;

}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strID = @"ID" ;
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:strID] ;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID] ;
        cell.textLabel.textAlignment = NSTextAlignmentCenter ;
        cell.selectionStyle  = UITableViewCellSelectionStyleNone ;
    }
    
    
    AppDelegate* de = GetAppDelegate() ;
    
    if (de.isLogin == YES)
    {
        cell.textLabel.text =  @"退出登录";
    }
    else
    {
        cell.textLabel.text = @"登录";
    }
    
    
    return cell ;
}

-(void) viewWillAppear:(BOOL)animated
{
    [_tableView reloadData] ;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击登录按钮
    if (indexPath.row == 0)
    {
        //退出登录画面
            AppDelegate* de = GetAppDelegate() ;
        if (de.isLogin == YES)
        {
            UIAlertView* alv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"即将退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] ;
            
            [alv show] ;
        }
        else
        {
            VCLogin* login = [[VCLogin alloc] init] ;

            [self presentViewController:login animated:YES completion:nil] ;
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //通知服务器退出登录
    if (buttonIndex == 0) {
        
    }
    else
    {
        AppDelegate* de = GetAppDelegate() ;
        de.isLogin = NO ;
        [_tableView reloadData] ;
        
    }
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
