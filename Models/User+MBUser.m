//
//  User+MBUser.m
//  Marble
//
//  Created by Iru on 10/2/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "User+MBUser.h"

#import "Utility.h"

@implementation User (MBUser)

- (NSString *)profileURL
{
    return [NSString stringWithFormat:@"//graph.facebook.com/%@/picture?type=square", self.fbID];
}

+ (BOOL)createUsersInBatchForEng:(NSArray *)fbEngUsers andChinese:(NSArray *)fbChUsers inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (fbEngUsers == nil || fbChUsers == nil) return FALSE;
    NSArray *fbIDs = [[fbEngUsers valueForKey:@"id"] sortedArrayUsingSelector: @selector(compare:)];
//    MBDebug(@"fb ids: %@", fbIDs);
    
    // create the fetch request to get all Employees matching the IDs
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(fbID IN %@)", fbIDs]];
    
    // Make sure the results are sorted as well.
    [fetchRequest setSortDescriptors:
     @[ [[NSSortDescriptor alloc] initWithKey: @"fbID" ascending:YES] ]];
    // Execute the fetch.
    NSError *error;
    NSArray *usersMatchingFbIDs = [[[context executeFetchRequest:fetchRequest error:&error] valueForKey:@"fbID"] sortedArrayUsingSelector: @selector(compare:)];
    
    MBDebug(@"Matching IDs: %@", usersMatchingFbIDs);
    
    [context setUndoManager:nil];
    
    //Set up the predicate for checking Chinese names
    NSString *predicateString = [NSString stringWithFormat:@"id == $FB_ID"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    
    int count = 0;
    int total = 0;
    for (NSDictionary<FBGraphUser>* user in fbEngUsers) {
//        MBDebug(@"Work on User %@", user.id);
        NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"SELF = %@", user.id];
        NSArray *matches = [usersMatchingFbIDs filteredArrayUsingPredicate:idPredicate];
        if ([matches count] != 0) {
            MBDebug(@"User %@ exists.", [matches firstObject]);
            continue; }
        
        NSString *name = nil;
        NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:@{ @"FB_ID" : user.id }];
        NSArray *filteredArray = [fbChUsers filteredArrayUsingPredicate:localPredicate];
        if ([filteredArray count] != 0) {
            NSDictionary<FBGraphUser> *chUser = filteredArray[0];
            
            if ([chUser.name isEqualToString:user.name]) {
                name = user.name;
            } else {
                name = [NSString stringWithFormat:@"%@ (%@)", user.name, chUser.name];
            }
        } else {
            name = user.name;
        }
        
        [User createNewUserWithName:name andfbID:user.id inManagedObjectContext:context];
        count++;
        total++;
        if (count >= 200) {
            count = 0;
            [Utility saveToPersistenceStore:context failureMessage:@"Failed to create users in batch."];
        }
    }
    MBDebug(@"Created %d users", total);
    
    [Utility saveToPersistenceStore:context failureMessage:@"Failed to create users in batch."];
    
//    NSFetchRequest *testfetchRequest = [[NSFetchRequest alloc] init];
//    [testfetchRequest setEntity:
//     [NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
//    
//    // Execute the fetch.
//    NSArray *test = [context executeFetchRequest:fetchRequest error:&error];
//    MBDebug(@"Number of users: %ld", [test count]);
    return TRUE;
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
        NSLog(@"User %@ found", (*userToReturn).name);
        return TRUE;
    } else {
        *userToReturn = [User createNewUserWithName:name andfbID:fbID inManagedObjectContext:context];
        return FALSE;
    }

    return true;
}

+(BOOL) getUserNameByFBID:(NSString *)fbid
              returnInName:(NSString **)name
    inManagedObjectContext:(NSManagedObjectContext *)context{
    NSError *error = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"fbID = %@", fbid];
    NSArray *matches = [context
                        executeFetchRequest:request error:&error];
    
    //    NSLog(@"Let's compare %@ and %@", fbid, [[matches firstObject] fbUserID]);
    
    if(!matches || error){
        NSLog(@"Errors in fetching entity");
        *name = nil;
        return FALSE;
    } else if([matches count]){
        User *user = [matches firstObject];
        *name = user.name;
        return TRUE;
    } else {
        *name = nil;
        return FALSE;
    }
    
    return false;

}

+ (BOOL)searchUserThatContains:(NSString *)string
           returnThisManyUsers:(int)num
                   inThisArray:(NSArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context{
    NSError *error = nil;
    NSMutableArray *allMatches = [[NSMutableArray alloc] init];
    [allMatches addObjectsFromArray:[User returnSearchArrayWithString:string inContext:context]];
    
    
    if([string rangeOfString:@" "].location != NSNotFound){
        NSArray* substrings = [string componentsSeparatedByString: @" "];
        for(NSString * substr in substrings){
            NSLog(@"%@", substr);
            NSArray *matches = [User returnSearchArrayWithString:substr inContext:context];
            for(id match in matches){
                if(![allMatches containsObject:match]){
                    [allMatches addObject:match];
                }
            }
        }
    }

    if(!allMatches || error){
        NSLog(@"Errors in fetching entity");
        *usersToReturn = nil;
        return FALSE;
    } else if([allMatches count]){
        if([allMatches count] > num){
            *usersToReturn = [allMatches subarrayWithRange:NSMakeRange(0, (int)num)];
        } else{
            *usersToReturn = allMatches;
        }
        return TRUE;
    }
    return FALSE;
}

+ (BOOL)getRandomUsersThisMany:(int)num
                   inThisArray:(NSArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context
                 existingUsers:(NSArray *)existingUsers{
    
    NSFetchRequest *myRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self IN %@)", existingUsers];
    [myRequest setPredicate:predicate];
    NSError *error = nil;
    NSUInteger myUserCount = [context countForFetchRequest:myRequest error:&error];
    [Utility saveToPersistenceStore:context failureMessage:@"Failed to save to persistent store in MBUser"];
    
    NSUInteger randomNumber = arc4random() % (myUserCount - [existingUsers count]-2);

    NSFetchRequest *myUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    [myUserRequest setPredicate:predicate];
    [myUserRequest setFetchLimit:(randomNumber + num - 1)];
    [myUserRequest setFetchOffset:randomNumber];
    NSArray *users = [context executeFetchRequest:myUserRequest error:&error];

    *usersToReturn = users;
    return TRUE;
}

//+(User *)getOneRandomUserInManagedObjectContext:(NSManagedObjectContext *)context{
//    NSFetchRequest *myRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
//    NSError *error = nil;
//    NSUInteger myUserCount = [context countForFetchRequest:myRequest error:&error];
//    
//    int randomNumber = arc4random() % myUserCount;
//    
//    NSFetchRequest *myUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
//    [myUserRequest setFetchOffset:randomNumber];
//    [myUserRequest setPredicate:NULL];
//    [myUserRequest setFetchLimit:1];
//    NSArray *users = [context executeFetchRequest:myUserRequest error:&error];
//    return [users firstObject];
//}
//

+(User *)createNewUserWithName:(NSString *)name andfbID:(NSString *)fbID inManagedObjectContext:(NSManagedObjectContext *)context{
    
    // found nothing, create it!
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                               inManagedObjectContext:context];
    [user setFbID:fbID];
    [user setName:name];
    
//    MBDebug(@"Created a user with name %@", name);
    return user;
}

+(NSArray *)returnSearchArrayWithString:(NSString *)string inContext:(NSManagedObjectContext *)context{
    if([string isEqualToString:@""]){
        return [[NSArray alloc] initWithObjects: nil];
    }
    
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", string];
    
    NSArray *matches = [context
                        executeFetchRequest:request error:&error];
    return matches;

}




@end
