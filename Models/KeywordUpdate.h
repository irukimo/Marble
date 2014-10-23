//
//  KeywordUpdate.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Post.h"


@interface KeywordUpdate : Post

@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSString * name;

@end
