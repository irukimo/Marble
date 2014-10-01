//
//  Quiz.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Quiz : NSManagedObject

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorProfileURL;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSString * option0;
@property (nonatomic, retain) NSString * option0Name;
@property (nonatomic, retain) NSString * option0ProfileURL;
@property (nonatomic, retain) NSString * option1;
@property (nonatomic, retain) NSString * option1Name;
@property (nonatomic, retain) NSString * option1ProfileURL;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSSet *authorship;
@property (nonatomic, retain) User *options;
@end

@interface Quiz (CoreDataGeneratedAccessors)

- (void)addAuthorshipObject:(User *)value;
- (void)removeAuthorshipObject:(User *)value;
- (void)addAuthorship:(NSSet *)values;
- (void)removeAuthorship:(NSSet *)values;

@end
