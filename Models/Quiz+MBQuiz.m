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

- (void)commmentsNum
{
    [self.comments count];
}

- (void)initParentAttributes
{
    if (self.author != nil) {
        [self setFbID1:[NSString stringWithString:self.author]];
        MBDebug(@"fb ID1: %@", self.fbID1);
    }
    if (self.option0 != nil) [self setFbID2:[NSString stringWithString:self.option0]];
    if (self.option1 != nil) [self setFbID3:[NSString stringWithString:self.option1]];
    if (self.keyword != nil) [self setKeyword1:[NSString stringWithString:self.keyword]];
}


@end
