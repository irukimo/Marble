//
//  Quiz+MBQuiz.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/8/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "Quiz+MBQuiz.h"
#import "NSNumber+MBNumber.h"

@implementation Quiz (MBQuiz)

- (void)incrementCompareNum
{
    [self setCompareNum:[[self compareNum] increment]];
}

@end
