//
//  KeywordUpdate+MBKeywordUpdate.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordUpdate+MBKeywordUpdate.h"

@implementation KeywordUpdate (MBKeywordUpdate)

- (void)initFBIDs
{
    MBDebug(@"keyword update init FBIDs");
    if (self.fbID != nil) {
        [self setFbID1:[NSString stringWithString:self.fbID]];
        MBDebug(@"fb ID1: %@", self.fbID1);
    }
}

@end
