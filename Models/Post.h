//
//  Post.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) id comments;
@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * fbID1;
@property (nonatomic, retain) NSString * fbID2;
@property (nonatomic, retain) NSString * fbID3;

@end
