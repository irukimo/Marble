//
//  KeywordProfileViewController.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordProfileViewController.h"

@interface KeywordProfileViewController()

@property (strong, nonatomic) NSString *keyword;
@end



@implementation KeywordProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbarTitle];
    self.type = KEYWORD_POSTS_TYPE;
    self.delegate = self;
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void) setNavbarTitle{
    NSString *paren = @"\"";
    NSString *title = [[paren stringByAppendingString:_keyword] stringByAppendingString:paren];
    [self setTitle:title];
}



-(void) setKeyword:(NSString *)keyword{
    _keyword = keyword;
}

@end
