//
//  CheckBox.m
//  iCartooniGame
//
//  Created by qianfeng on 14-8-7.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox

@synthesize on = _isON ;


-(id) initWithCoder:(NSCoder *)aDecoder
{
    static int counter = 0 ;
    counter++ ;
    NSLog(@"c = %d",counter) ;
    CGRect frame ;
    frame.origin.x = 0 ;
    frame.origin.y = 0 ;
    frame.size.width = 23;
    frame.size.height = 23;
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _checkView = [[UIImageView alloc] initWithFrame:frame];
        _normalImage = [UIImage imageNamed:@"noselected.png"];
        _selectedImage = [UIImage imageNamed:@"selected.png"];
        
        _isON = NO;
        _checkView.image = _normalImage;
        
        [self addSubview:_checkView];
    }
    return self;
}
//-(id) init
//{
//    CGRect frame ;
//    frame.origin.x = 0 ;
//    frame.origin.y = 0 ;
//    frame.size.width = 23;
//    frame.size.height = 23;
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        _checkView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _normalImage = [UIImage imageNamed:@"noselected.png"];
//        _selectedImage = [UIImage imageNamed:@"selected.png"];
//        
//        _isON = NO;
//        _checkView.image = _normalImage;
//        
//        [self addSubview:_checkView];
//        
//    }
//    return self;
//}

//- (id)initWithFrame:(CGRect)frame
//{
//    frame.size.width = 23;
//    frame.size.height = 23;
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        _checkView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _normalImage = [UIImage imageNamed:@"noselected.png"];
//        _selectedImage = [UIImage imageNamed:@"selected.png"];
//        
//        _isON = NO;
//        _checkView.image = _normalImage;
//        
//        [self addSubview:_checkView];
//        
//    }
//    return self;
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.on = !(self.on);
}

- (void)setOn:(BOOL)on
{
    if (_isON != on)
    {
        _isON = on;
        
        if (_isON)
        {
            _checkView.image = _selectedImage;
        }
        else
        {
            _checkView.image = _normalImage;
        }
        
        if ([_target respondsToSelector:_action])
        {
            [_target performSelectorOnMainThread:_action withObject:self waitUntilDone:NO] ;
            
            //[_target performSelector:_action withObject:self];
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (UIControlEventValueChanged & controlEvents)
    {
        _target = target;
        _action = action;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
