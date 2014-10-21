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
    leftBorder.frame = CGRectMake(offset, 0, width, 500);
    [view.layer addSublayer:leftBorder];
}
+(void) addRightBorderOn:(UIView *)view withColor:(UIColor *)color andWidth:(int)width andHeight:(int)height withOffset:(int) offset{
    CALayer *rightBorder = [CALayer layer];
    rightBorder.backgroundColor = color.CGColor;
    rightBorder.frame = CGRectMake(view.frame.size.width - offset - width, 0, width, 500);
    [view.layer addSublayer:rightBorder];
}
@end
