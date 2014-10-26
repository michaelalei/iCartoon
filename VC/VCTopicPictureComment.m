//
//  VCTopicPictureComment.m
//  iCartooniGame
//
//  Created by qianfeng on 14-8-3.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "VCTopicPictureComment.h"
#import "TopicImageCell.h"
#import "CommentCell.h"
#import "VCPictureTopicScrollShow.h"
#import "VCPostWarn.h"

@interface VCTopicPictureComment ()

@end

@implementation VCTopicPictureComment

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) loadData
{
    _mDicDataRoot = [[NSMutableDictionary alloc] init];
    [_mDicDataRoot setObject:_mMainImage forKey:@"image"] ;
    
    _mArrayData = [[NSMutableArray alloc] init] ;
    for (int i = 0 ; i < 10 ; i++)
    {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init] ;
        [dic setObject:[NSString stringWithFormat:@"发布者%d",i] forKey:@"author"] ;
        [dic setObject:@"内容:发呆；激发；减肥了看大家发快乐大家快乐；房间打开了；房间打开垃圾疯狂老大减肥快乐；da房间打开；了撒减肥了；大家分了看；打算减肥了肯定；就啊了看法；嗲了；房间打开了；sa就分开了；大家是来看发动机了咖啡机大厦里看见费德勒卡减肥的快垃圾分类看到就分开了；d；放假啊的快乐；减肥的离开；阿减肥了看大世界法律扩大进口理发店撒娇离开房间打开了分解大师看了；飞机到了撒看；jfldsajflkdajflkadjlkfjdaslkfjdlsakf将开放；阿大家分了看大家发垃圾了；放大瞬间放大了；减肥老大减肥可老大减肥了看大家发可老大减肥了aaa大家来发动机啊了附近的了撒减肥了的咖啡机老大减肥了；大风大家分了看打击了看法；jadlkfa" forKey:@"content"] ;
        [dic setObject:@"2014年12月" forKey:@"date"];
        
        [_mArrayData addObject:dic] ;
    }
    
    [_mDicDataRoot setObject:_mArrayData forKey:@"commentList"] ;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor] ;
    
    [self loadData];
    //return ;
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;

    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 458) style:UITableViewStylePlain];
    
    _mTableView.delegate = self ;
    _mTableView.dataSource = self ;
    
    [self.view addSubview:_mTableView] ;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mArrayData.count+1 ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        NSString* strImage = @"ImageID" ;
        TopicImageCell* cell = [tableView dequeueReusableCellWithIdentifier:strImage] ;
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicImageCell" owner:self options:nil] lastObject] ;
            cell.mLBPostComment.userInteractionEnabled = YES ;
            cell.mLBPostWarn.userInteractionEnabled = YES ;
            
            UITapGestureRecognizer* tapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapComment:)] ;
            
            [cell.mLBPostComment addGestureRecognizer:tapComment] ;
            
            UITapGestureRecognizer* tapWarn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWarn:)] ;
            
            [cell.mLBPostWarn addGestureRecognizer:tapWarn] ;
        }
        
        cell.mainImage.image = [_mDicDataRoot objectForKey:@"image"];
        return cell ;
    }
    else
    {
        NSString* strComment = @"Comment" ;
        CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:strComment] ;
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject] ;
        }
        NSDictionary* dic = [_mArrayData objectAtIndex:indexPath.row-1] ;
        NSString* strAuthor = [dic objectForKey:@"author"] ;
        NSString* strDate = [dic objectForKey:@"date"] ;
        NSString* strContent = [dic objectForKey:@"content"] ;
        
        cell.mAuthorLB.text = strAuthor ;
        cell.mCotentLB.text = strContent ;
        cell.mDateLB.text = strDate ;
        
        //cell.mCotentLB.numberOfLines = 0 ;

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize expectedLabelSize = [strContent boundingRectWithSize:CGSizeMake(280, 800) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        CGRect frame = [strContent boundingRectWithSize:CGSizeMake(280, 300) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil] ;
        NSLog(@"height = %f",frame.size.height);
        cell.mCotentLB.frame = CGRectMake(20, 40, 280, expectedLabelSize.height);
        return cell ;
    }
}

-(void) tapComment:(UITapGestureRecognizer*) tap
{
    
}

-(void) tapWarn:(UITapGestureRecognizer*) tap
{
    VCPostWarn* pw = [[VCPostWarn alloc] init] ;
    
    pw.mImage = self.mMainImage ;
    
    [self presentViewController:pw animated:YES completion:nil] ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 380 ;
    }
    else
    {
        NSDictionary* dic = [_mArrayData objectAtIndex:indexPath.row-1] ;
        NSString* strContent = [dic objectForKey:@"content"] ;
        CGRect frame = [strContent boundingRectWithSize:CGSizeMake(280, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil] ;
        return frame.size.height + 100 ;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        VCPictureTopicScrollShow* picVC = [[VCPictureTopicScrollShow alloc] init] ;
        [self.navigationController pushViewController:picVC animated:YES] ;
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
