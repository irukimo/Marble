//
//  User+MBUser.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "User+MBUser.h"

@implementation User (MBUser)

- (NSString *)profileURL
{
    return [NSString stringWithFormat:@"//graph.facebook.com/%@/picture?type=square", self.fbID];
}

@end
