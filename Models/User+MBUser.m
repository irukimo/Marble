//
//  User+MBUser.m
//  Marble
//
//  Created by Iru on 10/2/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "User+MBUser.h"

@implementation User (MBUser)

- (NSString *)profileURL
{
    return [NSString stringWithFormat:@"//graph.facebook.com/%@/picture?type=square", self.fbID];
}
+ (BOOL)findOrCreateUserForName:(NSString *)name
                       withfbID:(NSString *)fbID
                 returnAsEntity:(User **)userToReturn
         inManagedObjectContext:(NSManagedObjectContext *)context{
    NSError *error = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"fbID = %@ AND name = %@", fbID, name];
    NSArray *matches = [context
                        executeFetchRequest:request error:&error];
    
//    NSLog(@"Let's compare %@ and %@", fbid, [[matches firstObject] fbUserID]);
    
    if(!matches || error){
        NSLog(@"Errors in fetching entity");
        *userToReturn = nil;
        return FALSE;
    } else if([matches count]){
        *userToReturn = [matches firstObject];
        NSLog(@"user found");
        return TRUE;
    } else {
        *userToReturn = [User createNewUserWithName:name andfbID:fbID inManagedObjectContext:context];
        return FALSE;
    }

    return true;
}

+ (BOOL)searchUserThatContains:(NSString *)string
           returnThisManyUsers:(int)num
                   inThisArray:(NSArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context{
    NSError *error = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", string];
    NSArray *matches = [context
                        executeFetchRequest:request error:&error];
    if(!matches || error){
        NSLog(@"Errors in fetching entity");
        *usersToReturn = nil;
        return FALSE;
    } else if([matches count]){
        if([matches count] > num){
            *usersToReturn = [matches subarrayWithRange:NSMakeRange(0, (int)num - 1)];
        } else{
            *usersToReturn = matches;
        }
        return TRUE;
    }
    return FALSE;
}

+(User *)createNewUserWithName:(NSString *)name andfbID:(NSString *)fbID inManagedObjectContext:(NSManagedObjectContext *)context{
    
    // found nothing, create it!
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                               inManagedObjectContext:context];
    [user setFbID:fbID];
    [user setName:name];
    
    NSLog(@"Created a user with name %@", name);
    return user;
}

@end
