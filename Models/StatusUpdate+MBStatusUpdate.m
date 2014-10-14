//
//  StatusUpdate+MBStatusUpdate.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "StatusUpdate+MBStatusUpdate.h"

@implementation StatusUpdate (MBStatusUpdate)


- (void) initFBIDs
{
    MBDebug(@"status update init FBIDs");
    if (self.fbID != nil) {
        [self setFbID1:[NSString stringWithString:self.fbID]];
    }
}

@end
