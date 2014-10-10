//
//  StatusUpdate.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/9/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Post.h"


@interface StatusUpdate : Post

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * uuid;

@end
