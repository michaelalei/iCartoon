//
//  MyImageDownload.m
//  MyFreeLimit
//
//  Created by qianfeng on 14-9-5.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "MyImageDownload.h"
#import "NSString+Hashing.h"

@implementation MyImageDownload

//通过地址来创建一个沙盒中的路径
-(NSString*) getFullPath:(NSString*) strImageURL
{
    //appID 431431242121+时间+.png
    //http://api.douban.com/api/fdjalfda.png
    //MD5码：128bit 编码,只有字母和数字
    //MIT ：麻省理工学院
    //fdjalfdsafdlasl432431fdad4324314321
    
    NSString* strHome = [NSHomeDirectory() stringByAppendingString:@"/Library/Cache/QFCache02"] ;
    //将地址连接转为MD5码
    NSString* strMD5 = [strImageURL MD5Hash] ;
    
    NSString* strFullPath = [NSString stringWithFormat:@"%@/%@",strHome,strMD5] ;
    
    return strFullPath ;
}

//判断沙盒中是否存在要下载的图片
//参数为图片连接
-(BOOL) isHasImageInCache:(NSString*) strImageURL
{
    NSString* strFullPath = [self getFullPath:strImageURL] ;
    //判断沙盒中是否存在文件
    //YES为存在
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:strFullPath] ;

    return isExit ;
}

//判断是否已经过了有效时间
//如果超过有效时间:(一周)
//重新从服务器下载

//如果返回为YES:超时
//NO为未超时
-(BOOL) isTimeOut:(NSString*) strImageURL
{
    //获得硬盘中沙盒的全路径
    NSString* strFullPath = [self getFullPath:strImageURL] ;
    
    //获得沙盒中文件的属性信息
    NSDictionary* dicFile = [[NSFileManager defaultManager] attributesOfItemAtPath:strFullPath error:nil] ;
    //获得文件存盘时的时间
    NSDate* dataFile = [dicFile objectForKey:NSFileModificationDate] ;
    
    //获得当前的时间(距离1970时间长度)
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970] ;
    
    //获得文件距离1970时间长度
    NSTimeInterval lastTime = [dataFile timeIntervalSince1970] ;
    
    //当时间超过7天,超时
    if ((curTime - lastTime)> 24*7*60*60) {
        return YES ;
    }
    
    return NO ;
}

//判断可否使用缓存文件
//1:文件在沙盒中存在
//2:文件没有超过有效时间
//条件1&2同时满足时可以使用本地文件
//否则从服务器重新下载
-(BOOL) isUseCacheFile:(NSString*) strImageURL
{
    if ([self isHasImageInCache:strImageURL] == YES)
    {
        return YES ;
        if ([self isTimeOut:strImageURL] == NO) {
            return YES ;
        }
    }
    return NO ;
}

//下载
-(void) downloadImage:(NSString *)strURL tag:(NSUInteger)tag ID:(NSString *)strID
{
    _strID = strID ;
    _tag = tag ;
    _strImageURL = strURL ;
    
    //从本地缓存中读取
    if ([self isUseCacheFile:strURL] == YES)
    {
        UIImage* image = [self readFileFromCache:strURL] ;
        
        if (_delegate)
        {
            [_delegate finishImageDown:image withTag:_tag andID:_strID] ;
        }
    }
    //从服务器重新下载
    else
    {
        [self startConnect:strURL] ;
    }
}

-(void) startConnect:(NSString*) strImageURL
{
    NSURL* url = [NSURL URLWithString:strImageURL] ;
    //不是用系统请求的缓存
    //每次重新下载
    //参数三:等待时间,超过60秒,取消下载
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60] ;
    
    _connect = [NSURLConnection connectionWithRequest:request delegate:self] ;
    
    [_delegate addConnect:_connect] ;
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init] ;
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data] ;
}
//下载完成
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_delegate != nil)
    {
        UIImage* image = [[UIImage alloc] initWithData:_data]  ;
        
        [_delegate finishImageDown:image withTag:_tag andID:_strID] ;
        //下载成功后存盘
        [self saveImage:_data withURL:_strImageURL] ;
    }
}

//保存到本地
-(void) saveImage:(NSData*) data withURL:(NSString*) imageURL
{
    NSString* strFullPath = [self getFullPath:imageURL] ;
    
    NSString* strHome = [NSHomeDirectory() stringByAppendingString:@"/Library/Cache/QFCache02"] ;
    
    //如果不存在,新建文件夹
    //存在,不创建
    BOOL isOK = [[NSFileManager defaultManager] createDirectoryAtPath:strHome withIntermediateDirectories:YES attributes:nil error:nil] ;
    
    //保存到沙盒中
    [_data writeToFile:strFullPath atomically:YES] ;
}
//读取数据从沙盒中
-(UIImage*) readFileFromCache:(NSString*) strURL
{
    NSString* strFPath = [self getFullPath:strURL] ;
    
    NSData* data = [NSData dataWithContentsOfFile:strFPath] ;
    
    UIImage* image = [[UIImage alloc] initWithData:data] ;
    
    return image ;
}

@end
