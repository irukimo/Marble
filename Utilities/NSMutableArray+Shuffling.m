//
//  NSMutableArray+Shuffling.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/20/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"
#import "User+MBUser.h"

@implementation NSMutableArray (Shuffling)


/*
 * isFriend == 1 AND received > 0: 50
 * isFriend == 1 AND created >  0: 30
 * isFriend == 1                 : 20
 * isFriend != 1 AND received > 0: 10
 * otherwise, 1
 *
 */
- (void)shuffleInOrder
{
    NSMutableArray *weights = [NSMutableArray array];
    NSMutableArray *result = [NSMutableArray array];
    NSInteger totalWeights = 0;
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        User *user = (User *)self[i];
//        MBDebug(@"found recevied %@, received %@, isFriend %@", [user name], [user received], [user isFriend]);
        if ([[user isFriend] boolValue] && ([[user received] intValue] > 0) ) {
//            MBDebug(@"cool found recevied %@, %@", [user name], [user received]);
            weights[i] = @20000;
            totalWeights += 20000;
        } else if ([[user isFriend] boolValue] && [[user created] intValue] > 0) {
            weights[i] = @500;
            totalWeights += 500;
        } else if ([[user isFriend] boolValue]) {
            weights[i] = @20;
            totalWeights += 20;
        } else if (![[user isFriend] boolValue] && [[user received] intValue] > 0) {
            weights[i] = @10;
            totalWeights += 10;
        } else {
            weights[i] = @1;
            totalWeights += 1;
        }
    }
    
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger dice = arc4random_uniform((unsigned int)totalWeights);
        User *user = [self findUserInWeightArray:weights ByWeight:dice withTotalWeight:(NSInteger *)&totalWeights];
        [result addObject:user];
        [self removeObject:user];
        
    }
    
    [self removeAllObjects];
    [self addObjectsFromArray:result];
//    
//    for (NSUInteger i = 0; i < count; ++i) {
//        NSInteger remainingCount = count - i;
//        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
//        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
//    }
}

- (User *) findUserInWeightArray:(NSMutableArray *)weights ByWeight:(NSInteger)weight withTotalWeight:(NSInteger *)totalWeights
{
    NSUInteger length = [weights count];
    NSInteger count = 0;
    NSInteger index = length - 1;
    for (NSInteger i = 0; i < length; ++i){
        // if we found it
        if ( (count + [weights[i] integerValue]) > weight && weight >= count) {
            (*totalWeights) -= [weights[i] integerValue];
            index = i;
            break;
        } else {
            count += [weights[i] integerValue];
        }
    }
    
    [weights removeObjectAtIndex:index];
    return self[index];
}

@end
