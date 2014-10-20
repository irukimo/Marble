//
//  User+MBUser.m
//  Marble
//
//  Created by Iru on 10/2/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "NSMutableArray+Shuffling.h"
#import "User+MBUser.h"

#import "Utility.h"

@implementation User (MBUser)

- (void) getStatusWithCallback:(void (^)(void))callbackBlock
{
    
}

- (NSString *)profileURL
{
    return [NSString stringWithFormat:@"//graph.facebook.com/%@/picture?type=square", self.fbID];
}

+ (BOOL)createUsersInBatchForEng:(NSArray *)fbEngUsers andChinese:(NSArray *)fbChUsers inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (fbEngUsers == nil || fbChUsers == nil) return FALSE;
//    MBDebug(@"fbEngUsers: %@, fbChUsers: %@", fbEngUsers, fbChUsers);
    NSArray *fbIDs = [fbEngUsers valueForKey:@"id"];
    if (fbIDs != nil) [fbIDs sortedArrayUsingSelector: @selector(compare:)];
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
        inManagedObjectContext:(NSManagedObjectContext *)context
                 existingUsers:(NSArray *)existingUsers {
    NSError *error = nil;
    MBDebug(@"LOAD more: existing users ids: %@", [existingUsers valueForKey:@"fbID"]);
    
    // strip out all the leading and trailing spaces
    NSString *strippedStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    /*
      * we may consider use compound predicate later to improve efficiency
      *
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedStr.length > 0) {
        searchItems = [strippedStr componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *orMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        //
        //      name CONTAINS[c] "Wen"
        //
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
    
        // master OR predicate
        [orMatchPredicates addObject:finalPredicate];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = nil;
    
    // match up the fields of the Product object
    finalCompoundPredicate =
    (NSCompoundPredicate *)[NSCompoundPredicate orPredicateWithSubpredicates:orMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    */

    
    
    NSMutableArray *allMatches = [[NSMutableArray alloc] init];
    MBDebug(@"Trying to search words: %@", strippedStr);
    [allMatches addObjectsFromArray:[User returnSearchArrayWithString:strippedStr
                                                            inContext:context
                                                        existingUsers:existingUsers]];
    
    NSPredicate *predicateTemplate = [NSPredicate
                              predicateWithFormat:@"fbID = $FBID"];
    
    if([strippedStr rangeOfString:@" "].location != NSNotFound){
        NSArray* substrings = [strippedStr componentsSeparatedByString: @" "];
        for(NSString * substr in substrings){
            NSMutableArray *newExistingUsers = [NSMutableArray arrayWithArray:existingUsers];
            [newExistingUsers addObjectsFromArray:allMatches];
            MBDebug(@"Trying to search words: %@", substr);
            NSArray *matches = [User returnSearchArrayWithString:substr
                                                       inContext:context
                                                   existingUsers:newExistingUsers];

            for(User *match in matches){
                NSPredicate *predicate = [predicateTemplate predicateWithSubstitutionVariables:
                                          @{@"FBID": match.fbID}];
                NSArray *residue = [newExistingUsers filteredArrayUsingPredicate:predicate];
                if([residue count] == 0){
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
        if([allMatches count] > num && num != -1){
            *usersToReturn = [allMatches subarrayWithRange:NSMakeRange(0, (int)num)];
        } else{
            *usersToReturn = allMatches;
        }
        MBDebug(@"After LOAD MORE: users ids: %@", [(*usersToReturn) valueForKey:@"fbID"]);
        return TRUE;
    }
    return FALSE;
}

+ (BOOL)getRandomUsersThisMany:(int)num
                   inThisArray:(NSArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context
                 existingUsers:(NSArray *)existingUsers{
    MBDebug(@"random: existing users ids: %@", [existingUsers valueForKey:@"fbID"]);
    NSFetchRequest *myRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self IN %@)", existingUsers];
    [myRequest setPredicate:predicate];
    NSError *error = nil;
    NSUInteger myUserCount = [context countForFetchRequest:myRequest error:&error];
    [Utility saveToPersistenceStore:context failureMessage:@"Failed to save to persistent store in MBUser"];
    


    NSFetchRequest *myUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    [myUserRequest setPredicate:predicate];
    if (num != -1) {
        NSUInteger randomNumber = arc4random() % (myUserCount - [existingUsers count]-2);
        [myUserRequest setFetchLimit:(randomNumber + num - 1)];
        [myUserRequest setFetchOffset:randomNumber];
    }
    
    NSMutableArray *users = [NSMutableArray arrayWithArray:[context executeFetchRequest:myUserRequest error:&error]];
    
    if (num == -1) {
        [users shuffle];
    }
    
    *usersToReturn = users;
//    MBDebug(@"After random: users ids: %@", [(*usersToReturn) valueForKey:@"fbID"]);
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

+(NSArray *)returnSearchArrayWithString:(NSString *)string
                              inContext:(NSManagedObjectContext *)context
                          existingUsers:(NSArray *)existingUsers{
    if([string isEqualToString:@""]){
        return [[NSArray alloc] init];
    }
    
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray *fbIDs = [existingUsers valueForKey:@"fbID"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[c] %@) AND NOT (fbID IN %@)", string, fbIDs];
    
    NSArray *matches = [context
                        executeFetchRequest:request error:&error];
    return matches;

}



@end
