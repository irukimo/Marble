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


// infiltration rate: 10%
- (bool)infiltrateTwoArrays:(NSMutableArray *)firstArray secondArray:(NSMutableArray *)secondArray
{
    NSUInteger firstCount = [firstArray count];
    NSUInteger secondCount = [secondArray count];
    if (firstCount != 0 && secondCount != 0) {
        NSUInteger limitingCount = (firstCount > secondCount) ? secondCount : firstCount;
        NSUInteger shuffleNum = limitingCount / 10;
        MBDebug(@"shuffle num: %d", shuffleNum);
        for (NSUInteger i = 0; i < shuffleNum; ++i) {
            NSUInteger firstIndex = arc4random_uniform(firstCount);
            NSUInteger secondIndex = arc4random_uniform(secondCount);
            
            id obj1 = [firstArray objectAtIndex:firstIndex];
            id obj2 = [secondArray objectAtIndex:secondIndex];
            [firstArray addObject:obj2];
            [firstArray exchangeObjectAtIndex:firstIndex withObjectAtIndex:firstCount];
            [firstArray removeLastObject];
            [secondArray addObject:obj1];
            [secondArray exchangeObjectAtIndex:secondIndex withObjectAtIndex:secondCount];
            [secondArray removeLastObject];
        }
        return true;
    } else {
        return false;
    }
}

- (void)infiltrateMultipleArrays:(NSArray *)arrayOfArrays
{
    NSUInteger count = [arrayOfArrays count];
    for (NSUInteger i = 0; i < (count - 1); ++i) {
        [self infiltrateTwoArrays:arrayOfArrays[i] secondArray:arrayOfArrays[i + 1]];
    }
}

- (NSArray *)filterOutZeroLengthArrays:(NSArray *)arrayOfArrays
{
    NSMutableArray *results = [NSMutableArray array];
    for (NSMutableArray *array in arrayOfArrays) {
        if ([array count] > 0) {
            [results addObject:array];
        }
    }
    return results;
}

- (void)aggregateArrays:(NSArray *)arrayOfArrays withAggregator:(NSMutableArray *)aggregator
{
    for(NSMutableArray *array in arrayOfArrays){
        [aggregator addObjectsFromArray:array];
    }
}

/*
 * isFriend == 1 AND received > 0: first
 * isFriend == 1 AND created >  0: second
 * isFriend == 1                 : third
 * isFriend != 1 AND received > 0: fourth
 * otherwise, fifth
 *
 */
- (void)shuffleInOrder
{
    NSMutableArray *firstKind = [NSMutableArray array];
    NSMutableArray *secondKind = [NSMutableArray array];
    NSMutableArray *thirdKind = [NSMutableArray array];
    NSMutableArray *fourthKind = [NSMutableArray array];
    NSMutableArray *fifthKind = [NSMutableArray array];
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        User *user = (User *)self[i];
        if ([[user isFriend] boolValue] && ([[user received] intValue] > 0) ) {
            [firstKind addObject:user];
        } else if ([[user isFriend] boolValue] && [[user created] intValue] > 0) {
            [secondKind addObject:user];
        } else if ([[user isFriend] boolValue]) {
            [thirdKind addObject:user];
        } else if (![[user isFriend] boolValue] && [[user received] intValue] > 0) {
            [fourthKind addObject:user];
        } else {
            [fifthKind addObject:user];
        }
    }
    MBDebug(@"Start infiltration");
    NSArray *arrayOfArrays = [self filterOutZeroLengthArrays:@[firstKind, secondKind, thirdKind, fourthKind, fifthKind]];
    [self infiltrateMultipleArrays:arrayOfArrays];
    
    [self removeAllObjects];
    [self aggregateArrays:(NSArray *)arrayOfArrays withAggregator:self];
}

/*
 * isFriend == 1 AND received > 0: 50
 * isFriend == 1 AND created >  0: 30
 * isFriend == 1                 : 20
 * isFriend != 1 AND received > 0: 10
 * otherwise, 1
 *
 */
/*
- (void)shuffleInOrderOld
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
}*/

@end
