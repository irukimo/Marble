//
//  Quiz.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/8/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quiz : NSManagedObject

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) id comments;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSString * option0;
@property (nonatomic, retain) NSString * option0Name;
@property (nonatomic, retain) NSString * option1;
@property (nonatomic, retain) NSString * option1Name;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * compareNum;

@end
