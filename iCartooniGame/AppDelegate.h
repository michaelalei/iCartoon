//
//  AppDelegate.h
//  iCartooniGame
//
//  Created by qianfeng on 14-7-30.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//是否登录
@property (assign,nonatomic)  BOOL isLogin ;
//是否是管理员
@property (assign,nonatomic)  BOOL isMaster ;

@property (strong, nonatomic) UIWindow *window;


@end

