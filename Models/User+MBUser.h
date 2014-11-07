//
//  User+MBUser.h
//  Marble
//

#import "User.h"
#import <Foundation/Foundation.h>

@interface User (MBUser)

- (NSString *)profileURL;
- (void) setHeartForKeywordAtRow:(NSUInteger)index toBool:(bool)hearted;

+ (BOOL)createUsersInBatchForEng:(NSArray *)fbEngUsers
                      andChinese:(NSArray *)fbChUsers
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)findOrCreateUserForName:(NSString *)name
                       withfbID:(NSString *)fbID
                 returnAsEntity:(User **)userToReturn
         inManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)searchUserThatContains:(NSString *)string
           returnThisManyUsers:(int)num
                   inThisArray:(NSArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context
                 existingUsers:(NSArray *)existingUsers;

+ (BOOL)getRandomUsersThisMany:(int)num
                   inThisArray:(NSArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context
                 existingUsers:(NSArray *)existingUsers;

+(BOOL) getUserNameByFBID:(NSString *)fbid
              returnInName:(NSString **)name
    inManagedObjectContext:(NSManagedObjectContext *)context;



@end
