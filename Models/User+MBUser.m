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
        NSLog(@"User %@ found", (*userToReturn).name);
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
    
    NSMutableArray *allMatches = [[NSMutableArray alloc] init];
    [allMatches addObjectsFromArray:[User returnSearchArrayWithString:string inContext:context]];
    
    if([string containsString:@" "]){
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
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", string];
    
    NSArray *matches = [context
                        executeFetchRequest:request error:&error];
    return matches;

}

@end
