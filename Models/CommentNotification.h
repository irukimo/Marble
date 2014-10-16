//
//  CommentNotification.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/16/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CommentNotification : NSManagedObject

@property (nonatomic, retain) NSString * commenterFBID;
@property (nonatomic, retain) NSString * commenterName;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * type;

@end
