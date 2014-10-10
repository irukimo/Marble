//
//  Post.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/10/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) id comments;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * time;

@end
