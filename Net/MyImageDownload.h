//
//  MyImageDownload.h
//  MyFreeLimit
//
//  Created by qianfeng on 14-9-5.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//下载完成协议
@protocol MyImageDownloadDelegate <NSObject>

-(void) finishImageDown:(UIImage*) image withTag:(NSUInteger) tag andID:(NSString*) strID ;

-(void) addConnect:(NSURLConnection*) connect ;

@end

//图片下载缓存类
@interface MyImageDownload : NSObject
<NSURLConnectionDataDelegate,
NSURLConnectionDelegate>
{
    //
    NSURLConnection* _connect ;
    //数据对象
    NSMutableData*   _data ;
}
//tag来识别下载的对象源
@property (assign,nonatomic) NSUInteger tag ;
//字符串ID设定对象标志
@property (retain,nonatomic) NSString*  strID ;
//图像地址连接
@property (retain,nonatomic) NSString* strImageURL ;

-(void) downloadImage:(NSString*) strURL tag:(NSUInteger) tag ID:(NSString*) strID ;

//定义代理对象
@property (assign,nonatomic) id<MyImageDownloadDelegate> delegate ;

@end

