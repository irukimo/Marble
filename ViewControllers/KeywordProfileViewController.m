//
//  KeywordProfileViewController.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordProfileViewController.h"

@interface KeywordProfileViewController()
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *creatorView;
@property (strong, nonatomic) UIView *timesPlayedView;
@property (strong, nonatomic) UIView *friendRankingView;
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
    [self prepareHeaderView];
    self.tableView.tableHeaderView = _headerView;
}

-(void) prepareHeaderView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [_headerView setBackgroundColor:[UIColor marbleLightGray]];
    
    _creatorView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 80, 90)];
    [_creatorView setBackgroundColor:[UIColor whiteColor]];
    _timesPlayedView = [[UIView alloc] initWithFrame:CGRectMake(5, 100, 80, 40)];
    [_timesPlayedView setBackgroundColor:[UIColor whiteColor]];
    _friendRankingView = [[UIView alloc] initWithFrame:CGRectMake(90, 0, 200, 150)];
    [_friendRankingView setBackgroundColor:[UIColor whiteColor]];
    
    
    

    [UIView addLeftBorderOn:_headerView withColor:[UIColor marbleLightGray] andWidth:5 andHeight:0 withOffset:5];
    [UIView addRightBorderOn:_headerView withColor:[UIColor marbleLightGray] andWidth:5 andHeight:0 withOffset:5];
    [_headerView.layer setBorderColor:[UIColor marbleLightGray].CGColor];
    [_headerView.layer setBorderWidth:5.0f];
    [_headerView addSubview:_creatorView];
    [_headerView addSubview:_friendRankingView];
    [_headerView addSubview:_timesPlayedView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavbarTitle];
}

-(void)viewDidAppear:(BOOL)animated{
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
