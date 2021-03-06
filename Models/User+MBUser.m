
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

- (void) setHeartForKeywordAtRow:(NSUInteger)index toBool:(bool)hearted
{
    NSMutableArray *keywords = [NSMutableArray arrayWithArray:self.keywords];
    NSMutableArray *keyword = [NSMutableArray arrayWithArray:[keywords objectAtIndex:(NSUInteger)index]];
    [keyword setObject:[NSNumber numberWithBool:hearted] atIndexedSubscript:3];
    NSInteger numLikes = [[keyword objectAtIndex:4] integerValue];
    if (hearted) {
        [keyword setObject:[NSNumber numberWithInteger:(numLikes + 1)] atIndexedSubscript:4];
    } else {
        [keyword setObject:[NSNumber numberWithInteger:(numLikes - 1)] atIndexedSubscript:4];
    }
    [keywords setObject:keyword atIndexedSubscript:(NSUInteger)index];
    [self setKeywords:keywords];
    [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:nil];
    
    MBDebug(@"Set heart to %@ for keyword %@", [[self.keywords objectAtIndex:index] objectAtIndex:3],
                                         [[self.keywords objectAtIndex:index] objectAtIndex:1]);
}

- (NSString *)profileURL
{
    return [NSString stringWithFormat:@"//graph.facebook.com/%@/picture?type=square", self.fbID];
}


+ (NSString *)combineCombinedNameInEngAndCh:(NSArray *)fbChUsers withUser:(NSDictionary<FBGraphUser> *)user withPredicateTemplate:(NSPredicate *)predicateTemplate
{
    NSPredicate *localPredicate = [predicateTemplate predicateWithSubstitutionVariables:@{ @"FB_ID" : user.id }];
    NSArray *filteredArray = [fbChUsers filteredArrayUsingPredicate:localPredicate];
    if ([filteredArray count] != 0) {
        NSDictionary<FBGraphUser> *chUser = filteredArray[0];
        
        if ([chUser.name isEqualToString:user.name]) {
            return user.name;
        } else {
            return [NSString stringWithFormat:@"%@ (%@)", user.name, chUser.name];
        }
    } else {
        return user.name;
    }
}

+ (BOOL)createUsersInBatchForEng:(NSArray *)fbEngUsers andChinese:(NSArray *)fbChUsers bilingual:(BOOL)bilingual inManagedObjectContext:(NSManagedObjectContext *)context
{
    if ( (fbEngUsers == nil || fbChUsers == nil) && bilingual ) {return FALSE;}
//    MBDebug(@"fbEngUsers: %@, fbChUsers: %@", fbEngUsers, fbChUsers);
    NSArray *fbIDs = [fbEngUsers valueForKey:@"id"];
    if (fbIDs != nil) [fbIDs sortedArrayUsingSelector: @selector(compare:)];
    MBDebug(@"fb ids: %@", fbIDs);
    
    // create the fetch request to get all users matching the IDs
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
        NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"self == %@", user.id];
        NSArray *matches = [usersMatchingFbIDs filteredArrayUsingPredicate:idPredicate];

//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        [fetchRequest setEntity:
//         [NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
//        [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"fbID == %@", user.id]];
        
        // Execute the fetch.
        NSString *name = nil;
//        NSError *error;
//        NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
        if ([matches count] != 0) {
//            MBDebug(@"User exists, %@.", [matches firstObject]);
            // check if the name contains both languages
            
            if (bilingual) {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                [fetchRequest setEntity:
                 [NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
                [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"fbID == %@", [matches firstObject]]];
                NSArray *users = [context executeFetchRequest:fetchRequest error:nil];
                User *existingUser = [users firstObject];
                name = [self combineCombinedNameInEngAndCh:fbChUsers withUser:user withPredicateTemplate:predicate];
                if (![name isEqualToString:existingUser.name]) {
                    MBDebug(@"About to change name: existing name: %@, new name: %@", existingUser.name, name);
                    [existingUser setName:name];
                }
            }
            continue;
        }
        
        if (bilingual) {
            name = [self combineCombinedNameInEngAndCh:fbChUsers withUser:user withPredicateTemplate:predicate];
        } else { // English only
            name = user.name;
        }
        
        [User createNewUserWithName:name andfbID:user.id isFriend:true inManagedObjectContext:context];
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
    request.predicate = [NSPredicate predicateWithFormat:@"fbID = %@", fbID];
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
        *userToReturn = [User createNewUserWithName:name andfbID:fbID isFriend:false inManagedObjectContext:context];
        return TRUE;
    }
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
                   inThisArray:(NSMutableArray **)usersToReturn
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
            *usersToReturn = [NSMutableArray arrayWithArray:[allMatches subarrayWithRange:NSMakeRange(0, (int)num)]];
        } else{
            *usersToReturn = [NSMutableArray arrayWithArray:allMatches];
        }
        MBDebug(@"After LOAD MORE: users ids: %@", [(*usersToReturn) valueForKey:@"fbID"]);
        return TRUE;
    }
    return FALSE;
}

/*   probability             predicate
 *
 * 1) 1   - 100 | [isFriend == 1 AND created > 0]: getOjbect of options will update users of the numbers
 * 2) 101 - 140 | [isFriend == 1 AND received > 0]:
 * 3) 141 - 150 | [isFriend == 1]:
 *
 */
+ (int) randomlySelectCategoryWithCategMap:(NSMutableArray *)categMap
{
    if (![categMap[0] boolValue] && ![categMap[1] boolValue] && ![categMap[2] boolValue]) {
        return 3; // 3 means error
    }
    
    NSUInteger dice = arc4random() % (150) + 1;
    if (dice <= 100 && [[categMap objectAtIndex:0] boolValue]) {
        return 0;
    } else if (dice > 101 && dice <= 140 && [[categMap objectAtIndex:1] boolValue]) {
        return 1;
    } else if ([[categMap objectAtIndex:2] boolValue]) {
        return 2;
    } else {
        return [self randomlySelectCategoryWithCategMap:categMap];
    }
}

+ (void)fetchTwoUsersWithCategMap:(NSMutableArray **)categMap
             usersToReturn:(NSMutableArray **)usersToReturn
             existingUsers:(NSArray *)existingUsers
                 inContext:(NSManagedObjectContext *)context
{
    int type = [self randomlySelectCategoryWithCategMap:*categMap];
    if (type == 3) {
        MBError(@"Error in randomly selecting categories");
        return;
    }

    NSPredicate *predicate = nil;
    switch (type) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"isFriend == 1 AND created > 0 AND NOT (self IN %@)", existingUsers];
            break;
            
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"isFriend == 1 AND received > 0 AND NOT (self IN %@)", existingUsers];
            break;
            
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"isFriend == 1 AND NOT (self IN %@)", existingUsers];
            break;
            
        default:
            break;
    }
    
    NSFetchRequest *myRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    [myRequest setPredicate:predicate];
    NSUInteger myUserCount = [context countForFetchRequest:myRequest error:nil];
    [Utility saveToPersistenceStore:context failureMessage:@"Failed to save to persistent store in MBUser"];
    MBDebug(@"type: %d number of users: %d", type, myUserCount);
    if (myUserCount == 0) { // not enough users that match the criteria
        (*categMap)[type] = @NO; // don't enter this category again
    } else if (myUserCount > 0) {
        if (myUserCount == 1) { (*categMap)[type] = @NO; }// don't enter this category again
        
        NSFetchRequest *myUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        [myUserRequest setPredicate:predicate];
        
        NSUInteger randomNumber = arc4random() % myUserCount;
        [myUserRequest setFetchLimit:randomNumber];
        [myUserRequest setFetchOffset:randomNumber];

        [(*usersToReturn) addObjectsFromArray:[context executeFetchRequest:myUserRequest error:nil]];
    }
    MBDebug(@"users to return: %d", [(*usersToReturn) count]);
    if ([(*usersToReturn) count] <= 1) {
        [self fetchTwoUsersWithCategMap:categMap usersToReturn:usersToReturn
                          existingUsers:[existingUsers arrayByAddingObjectsFromArray:*usersToReturn]
                              inContext:context];
    }
}

+ (BOOL)getRandomUsersThisMany:(int)num
                   inThisArray:(NSMutableArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context
                 existingUsers:(NSArray *)existingUsers{
    MBDebug(@"random: existing users ids: %@", [existingUsers valueForKey:@"fbID"]);
    
    /*   probability             predicate
      *
      * 1) 1   - 100 | [isFriend == 1 AND created > 0]: getOjbect of options will update users of the numbers
      * 2) 101 - 140 | [isFriend == 1 AND received > 0]:
      * 3) 141 - 150 | [isFriend == 1]:
      *
     */
    if ((*usersToReturn) == nil) {
        (*usersToReturn) = [NSMutableArray array];
    }
    if (num == 2) {
        NSMutableArray *categMap = [NSMutableArray arrayWithArray:@[@YES, @YES, @YES]];
        [self fetchTwoUsersWithCategMap:&categMap usersToReturn:usersToReturn existingUsers:existingUsers inContext:context];
    } else if (num == -1) {
        // for explore view
        NSFetchRequest *myUserRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        *usersToReturn = [NSMutableArray arrayWithArray:[context executeFetchRequest:myUserRequest error:nil]];
        [(*usersToReturn) shuffleInOrder];
    } else {
        MBError(@"Unexpected number of users wanted: %d", num);
    }

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

+(User *)createNewUserWithName:(NSString *)name andfbID:(NSString *)fbID isFriend:(bool)isFriend inManagedObjectContext:(NSManagedObjectContext *)context{
    
    // found nothing, create it!
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                               inManagedObjectContext:context];
    [user setFbID:fbID];
    [user setName:name];
    if (isFriend) {[user setIsFriend:@YES];}
    else {[user setIsFriend:@NO];}
    
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
