//
//  User.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/7/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSString * name;

@end
