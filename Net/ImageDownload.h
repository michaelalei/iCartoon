//
//  ImageDownload.h
//  MyFreeLimit
//
//  Created by qianfeng on 14-9-5.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//协议定义
@protocol ImageDownloadDelegate <NSObject>

//当下载成功后调用此函数
//参数为下载成功后的数据
-(void) finishImageDown:(UIImage*) data tag:(NSUInteger) tag strID:(NSString*) strID;

@end

@interface ImageDownload : NSObject
<NSURLConnectionDelegate,
NSURLConnectionDataDelegate>
{
    NSURLConnection* _connect ;
    NSMutableData*   _data ;
    NSString*        _strImageURL ;
}

@property (assign,nonatomic) NSUInteger tag;
@property (retain,nonatomic) NSString*  strID ;
//定义代理
@property (assign,nonatomic) id<ImageDownloadDelegate>delegate ;

//下载数据,开启异步下载操作
-(void) downloadImage:(NSString*) strImageURL ;

@end
