//
//  UIView+MBView.h
//  Marble
//
//  Created by Iru on 10/21/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(MBView)
+(void) addLeftBorderOn:(UIView *)view withColor:(UIColor *)color andWidth:(int)width andHeight:(int)height withOffset:(int) offset;
+(void) addRightBorderOn:(UIView *)view withColor:(UIColor *)color andWidth:(int)width andHeight:(int)height withOffset:(int) offset;
@end
