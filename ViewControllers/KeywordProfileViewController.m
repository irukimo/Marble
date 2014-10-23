//
//  KeywordProfileViewController.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordProfileViewController.h"

@interface KeywordProfileViewController()


@end

@implementation KeywordProfileViewController

- (void)viewDidLoad {
    self.predicate = [NSPredicate predicateWithFormat:@"keyword1 == %@ OR keyword2 == %@ OR keyword3 == %@", _keyword, _keyword, _keyword];
    self.basicParams =  @{@"keyword": _keyword};

    [super viewDidLoad];
    [self setNavbarTitle];
//    self.delegate = self;
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);

}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavbarTitle];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNavbarTitle];
}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [myNavBar setTitleTextAttributes:[Utility getNavigationBarTitleFontDictionary]];
    [[myNavBar topItem] setTitle:[NSString stringWithFormat:@"\"%@\"", _keyword]];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleOrange]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self setTitle:title];
}





-(void) setKeyword:(NSString *)keyword{
    _keyword = keyword;
}

@end
