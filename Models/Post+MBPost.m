//
//  Post+MBPost.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "Post+MBPost.h"
#import "NSNumber+MBNumber.h"

@implementation Post (MBPost)

- (void) initParentAttributes{}

+ (void)setIndicesAsRefreshing:(NSArray *)posts
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    NSSortDescriptor *sortByIndex = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortByIndex, nil]];
    [request setFetchLimit:1];
    NSArray *match = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:nil];
    NSNumber *smallestIndex = nil;
    if ([match count] > 1) {
        MBError(@"Fetched more than the fetch limit!");
        return;
    } else if ([match count] == 0){
        // Yet downloaded any posts
        smallestIndex = [NSNumber numberWithInt:0];
    } else {
        smallestIndex = [[match firstObject] index];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"popularity" ascending:YES];
    NSArray *sortedPosts = [posts sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    for (Post *post in sortedPosts) {
        if ([post.index isEqual:@0]) {
            if ([(smallestIndex = [smallestIndex decrement]) isEqual:@0] )
            {
                smallestIndex = [smallestIndex decrement];
            }
            
            [post setIndex:smallestIndex];
        }
    }
}

+ (void)setIndicesAsLoadingMore:(NSArray *)posts
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    NSSortDescriptor *sortByIndex = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortByIndex, nil]];
    [request setFetchLimit:1];
    NSArray *match = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:nil];
    if ([match count] > 1) {
        MBError(@"Fetched more than the fetch limit!");
    } else if ([match count] == 0){
        // an empty array
        // do nothing
        // Loading more should not happen when there were no posts before
    } else {
        NSNumber *biggestIndex = [[match firstObject] index];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"popularity" ascending:NO];
        NSArray *sortedPosts = [posts sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        for (Post *post in sortedPosts) {
            if ([post.index isEqual:@0]) {
                if ([(biggestIndex = [biggestIndex increment]) isEqual:@0])
                {
                    biggestIndex = [biggestIndex increment];
                }
                [post setIndex:biggestIndex];
            }
        }
    }
}

@end
