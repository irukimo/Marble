//
//  UIView+MBView.m
//  Marble
//
//  Created by Iru on 10/21/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "UIView+MBView.h"

@implementation UIView(MBView)
+(void) addLeftBorderOn:(UIView *)view withColor:(UIColor *)color andWidth:(int)width andHeight:(int)height withOffset:(int) offset{
    CALayer *leftBorder = [CALayer layer];
    leftBorder.backgroundColor = color.CGColor;
    int displayheight = (height < 500)? 500: height;
    leftBorder.frame = CGRectMake(offset, 0, width, displayheight);
    [leftBorder setZPosition:-100];
    [view.layer addSublayer:leftBorder];
}
+(void) addRightBorderOn:(UIView *)view withColor:(UIColor *)color andWidth:(int)width andHeight:(int)height withOffset:(int) offset{
    CALayer *rightBorder = [CALayer layer];
    rightBorder.backgroundColor = color.CGColor;
    int displayheight = (height < 500)? 500: height;
    rightBorder.frame = CGRectMake(view.frame.size.width - offset - width, 0, width, displayheight);
    [rightBorder setZPosition:-200];
    [view.layer addSublayer:rightBorder];
}

+(void)addBackgroundShadowOnView:(UIView *)view{
    view.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
    view.layer.shadowRadius = 2.f;
    view.layer.shadowOpacity = 1.f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
}

@end
