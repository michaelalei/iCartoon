//
//  ImageDownload.m
//  MyFreeLimit
//
//  Created by qianfeng on 14-9-5.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "ImageDownload.h"
#import "NSString+Hashing.h"

@implementation ImageDownload

-(BOOL) isUserLocalCache:(NSString*) strImageURL
{
   // return NO ;
    
    if ([self isHasImageInCache:strImageURL]
        )
    {
        NSLog(@"isExit!");
        if ([self timeNotOut:strImageURL])
        {
            NSLog(@"User Cache");
            return YES ;
        }

    }
    
    return NO ;
}

-(NSString*) getFullPath:(NSString*) strImageURL
{
    NSString* strPathDir = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Cache/QFCache"] ;
    
    NSString* md5Name = [strImageURL MD5Hash] ;
    
    NSString* strFullPath = [NSString stringWithFormat:@"%@/%@",strPathDir,md5Name] ;

    return strFullPath ;
}

-(BOOL) timeNotOut:(NSString*) strImageURL
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];

    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self getFullPath:strImageURL] error:nil];
    // 取得了文件上次修改的时间
    NSDate *lastDate = [dict objectForKey:NSFileModificationDate];
    NSTimeInterval lastTime =  [lastDate timeIntervalSince1970];

    //没有超时
    if (nowTime - lastTime < 24*60*60)
    {
        return YES ;
    }
    //超时
    else
    {
        return NO ;
    }
}

-(BOOL) isHasImageInCache:(NSString*) strImageURL
{
    NSString* strFullPath = [self getFullPath:strImageURL] ;
    
    NSLog(@"path = %@",strFullPath) ;
    
    
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:strFullPath] ;
    
    return isExit ;
}

-(UIImage*) readImageFromCache:(NSString*) strImageURL
{
    NSString* strFullPath = [self getFullPath:strImageURL] ;
    
    NSData* data =  [NSData dataWithContentsOfFile:strFullPath];
    
    UIImage* image = [UIImage imageWithData:data] ;
    
    return image ;
}

-(void) saveImageToCache:(NSData*) data
{
    NSString* strPathDir = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Cache/QFCache"] ;
    
    NSString* md5Name = [_strImageURL MD5Hash] ;
    
    NSString* strFullPath = [NSString stringWithFormat:@"%@/%@",strPathDir,md5Name] ;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:strPathDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    [data writeToFile:strFullPath atomically:YES] ;
}


-(void) downloadImage:(NSString*) strImageURL
{
    _strImageURL = strImageURL ;
    
    if ([self isUserLocalCache:strImageURL] == YES)
    {
        UIImage* image = [self readImageFromCache:strImageURL] ;
        
        [_delegate finishImageDown:image tag:_tag strID:_strID] ;
    }
    else
    {
        [self startConnect:strImageURL] ;
    }
}

-(void) startConnect:(NSString*) strImageURL
{
    //start download
    
    NSURL* url = [NSURL URLWithString:strImageURL] ;
    //使用默认缓存方式
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60] ;
    
    _connect = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
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
        UIImage* image = [UIImage imageWithData:_data];
        [_delegate finishImageDown:image tag:_tag strID:_strID] ;
        
        [self saveImageToCache:_data] ;
        
        //下载成功后,清空连接
        _connect = nil ;
    }
}

@end
