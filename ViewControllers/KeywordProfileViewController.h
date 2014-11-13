//
//  KeywordProfileViewController.h
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsViewController.h"

@interface KeywordProfileViewController :PostsViewController 
@property (strong, nonatomic) NSString *keyword;
-(void) setKeyword:(NSString *)keyword;
@end
