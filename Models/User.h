//
//  User.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/15/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * received;
@property (nonatomic, retain) NSNumber * created;
@property (nonatomic, retain) NSNumber * solved;
@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) id keywords;

@end
