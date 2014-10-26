//
//  NetDownload.h
//  MyFreeLimit
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

//协议定义
@protocol NetDownloadDelegate <NSObject>

//当下载成功后调用此函数
//参数为下载成功后的数据
@required
-(void) finishDownload:(NSData*) data tag:(NSUInteger) tag;

-(void) addConnect:(NSURLConnection*) connect ;

@end

@interface NetDownload : NSObject<NSURLConnectionDelegate,
    NSURLConnectionDataDelegate>
{
    NSURLConnection* _connect ;
    NSMutableData*   _data ;
}

@property (assign,nonatomic) NSUInteger tag;
//定义代理
@property (assign,nonatomic) id<NetDownloadDelegate>delegate ;

//下载数据,开启异步下载操作
-(void) downloadData:(NSString*) strURL ;


@end
