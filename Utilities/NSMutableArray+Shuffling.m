//
//  NSMutableArray+Shuffling.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/20/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
