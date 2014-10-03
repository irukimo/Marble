//
//  User+MBUser.h
//  Marble
//

#import "User.h"
#import <Foundation/Foundation.h>

@interface User (MBUser)

- (NSString *)profileURL;


+ (BOOL)findOrCreateUserForName:(NSString *)name
                       withfbID:(NSString *)fbID
                 returnAsEntity:(User **)userToReturn
         inManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)searchUserThatContains:(NSString *)string
           returnThisManyUsers:(int)num
                   inThisArray:(NSArray **)usersToReturn
        inManagedObjectContext:(NSManagedObjectContext *)context;
@end
