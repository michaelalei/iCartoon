//
//  VCSetting.m
//  iCartooniGame
//
//  Created by zhulei on 14-10-29.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCSetting.h"

@interface VCSetting ()

@end

@implementation VCSetting

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped] ;
    
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
        //cell.textLabel.textAlignment = NSTextAlignmentCenter ;
        cell.selectionStyle  = UITableViewCellSelectionStyleNone ;
        
        if (indexPath.row == 0)
        {
            UISwitch* sw= [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width-60, 6, 40, 40)] ;
            
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults] ;
            
            NSString* strID = [ud objectForKey:@"OnlyWifiPost"] ;
            
            if ([strID isEqualToString:@"NO"])
            {
                sw.on = NO ;
            }
            else
            {
                sw.on = YES ;
                
                if (strID == nil)
                {
                    [ud setObject:@"YES" forKey:@"OnlyWifiPost"] ;
                }
            }
            sw.tag = 1001 ;
            [sw addTarget:self action:@selector(pressWifiAct:) forControlEvents:UIControlEventValueChanged] ;
            [cell.contentView addSubview:sw] ;
        }
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"只使用wifi上传";
    }
    
    return cell ;
}

-(void) pressWifiAct:(UISwitch*) sw
{
    NSLog(@"aaa = %d",sw.on) ;
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults] ;
    if (sw.on)
    {
        [ud setObject:@"YES" forKey:@"OnlyWifiPost"] ;
    }
    else
    {
        [ud setObject:@"NO" forKey:@"OnlyWifiPost"] ;
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
