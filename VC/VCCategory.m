//
//  VCCategory.m
//  iCartooniGame
//
//  Created by Zhu Lei on 14-7-31.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCCategory.h"
#import "VCPictureList.h"

@interface VCCategory ()

@end

@implementation VCCategory

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = @"CG空间";
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Category" ofType:@"plist"] ;
        
        _arrayData = [[NSMutableArray alloc] initWithContentsOfFile:path] ;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    VCPictureList* pList = [[VCPictureList alloc] init] ;
//    
//    pList.view.backgroundColor = [UIColor blueColor];
//    [self.navigationController pushViewController:pList animated:NO] ;

    //self.view.window.screen.bounds.size.height-80
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped] ;
    
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    
    [self.view addSubview:_tableView] ;
    
    _mPictureList = [[VCPictureList alloc] init] ;
    NSDictionary* dic = [_arrayData objectAtIndex:0] ;
    NSString* strTitle = [dic objectForKey:@"group"] ;
    //pList.title = @"2D人物";
    _mPictureList.title = strTitle ;
    
    _mPictureList.view.backgroundColor = [UIColor blueColor];
    _mPictureList.mIsNeedUpdate = YES ;
    _mPictureList.categoryID = 0 ;
    [self.navigationController pushViewController:_mPictureList animated:YES] ;
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayData.count ;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* dic = [_arrayData objectAtIndex:section] ;
    NSArray* arrayD = [dic objectForKey:@"data"] ;
    return [arrayD count] ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strID = @"CategoryCell" ;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strID] ;
    if (cell== nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID] ;
        cell.textLabel.textAlignment = NSTextAlignmentCenter ;
    }
    
    NSDictionary* dic = [_arrayData objectAtIndex:indexPath.section] ;
    NSArray* arrayD = [dic objectForKey:@"data"] ;
    
    cell.textLabel.text = [arrayD objectAtIndex:indexPath.row] ;

    return cell ;
}


-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* dic = [_arrayData objectAtIndex:section] ;
    
    NSString* strTitle = [dic objectForKey:@"group"] ;
    
    return strTitle ;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mPictureList refreshUI] ;
    
    NSDictionary* dic = [_arrayData objectAtIndex:indexPath.section] ;
   // NSString* strTitle = [dic objectForKey:@"group"] ;

    NSArray* arrayD = [dic objectForKey:@"data"] ;
    
    NSString* strCategory = [arrayD objectAtIndex:indexPath.row] ;
    
    NSString*  strValue  = strCategory;
    if (indexPath.section == 0)
    {
        //strValue  = [NSString stringWithFormat:@"%@%@",strTitle,strCategory] ;
        _mPictureList.categoryID = indexPath.row ;
    }
    else
    {
        _mPictureList.categoryID = 0;
        for (int i = 0 ; i < indexPath.section; i++)
        {
            NSDictionary* dic = [_arrayData objectAtIndex:i] ;
            
            NSArray* arrayD = [dic objectForKey:@"data"] ;
            _mPictureList.categoryID+= arrayD.count ;
        }
        _mPictureList.categoryID += indexPath.row ;
    }
    
    _mPictureList.title = strValue ;

    NSLog(@"categoryID = %lu",_mPictureList.categoryID) ;
    
    _mPictureList.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:_mPictureList animated:YES] ;
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
