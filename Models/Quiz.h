//
//  Quiz.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/15/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Post.h"


@interface Quiz : Post

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSNumber * option0Num;
@property (nonatomic, retain) NSNumber * option1Num;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSString * option0;
@property (nonatomic, retain) NSString * option0Name;
@property (nonatomic, retain) NSString * option1;
@property (nonatomic, retain) NSString * option1Name;
@property (nonatomic, retain) NSString * guessed;

@end
