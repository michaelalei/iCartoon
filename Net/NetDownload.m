//
//  NetDownload.m
//  MyFreeLimit
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "NetDownload.h"

@implementation NetDownload


-(void) downloadData:(NSString *)strURL
{
    if (_connect != nil)
    {
        NSLog(@"上次下载没有结束");
        return ;
    }
    NSURL* url = [NSURL URLWithString:strURL] ;
    //使用默认缓存方式
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    
    _connect = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
    
    [_delegate addConnect:_connect] ;
    
    //启动连接
    [_connect start] ;
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //如果statusCode == 200 ;
    _data = [[NSMutableData alloc] init] ;
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data] ;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_delegate != nil)
    {
        [_delegate finishDownload:_data tag:_tag] ;
        //下载成功后,清空连接
        _connect = nil ;
    }
}

@end
