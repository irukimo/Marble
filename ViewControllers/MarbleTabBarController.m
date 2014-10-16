//
//  MarbleTabBarController.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "MarbleTabBarController.h"
#import "ProfileNavigationController.h"
#import "HomeNavigationController.h"
#import "CommentsTableViewController.h"
#import "PostsViewController.h"

#define AUTO_COMPLETE_SELECT_VIEW_TAG 999
#define COMMENT_TEXT @"write a comment..."

@interface MarbleTabBarController ()
@property (strong, nonatomic) CreateQuizViewController *createQuizViewController;
@property (strong, nonatomic) SelectPeopleViewController *selectPeopleViewController;
@property (strong, nonatomic) SelectKeywordViewController *selectKeywordViewController;
@property (strong, nonatomic) CommentsTableViewController *commentsTableViewController;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *createQuizWholeView;
@property (strong, nonatomic) UIScrollView *commentsWholeView;
@property(strong, nonatomic) UITextField *commentField;
@property(strong, nonatomic) UIButton *commentBtn;
@property (strong, nonatomic) UIView *commentFieldView;
@property (nonatomic) BOOL isCreatingMarble;
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) UIViewAnimationCurve keyboardCurve;
@property ( nonatomic) CGRect commentsTableViewFrame;
@property (nonatomic) CGRect commentFieldViewFrame;
@property (weak, nonatomic) id callerViewController;
@property (strong, nonatomic) NSIndexPath *commentIndexPath;
@property (nonatomic) NSUInteger commentNum;
@end

@implementation MarbleTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewFrames];
    [self initCreateQuizView];
    [self initCommentsTableView];
    [self registerForKeyboardNotifications];
    self.delegate = self;
    _isCreatingMarble = FALSE;

    
    //set tabbaritem image
    [self setTabBarItemImages];
    // set tabbaritem font
    NSDictionary *selectedFont = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor marbleOrange] ,NSForegroundColorAttributeName,nil];
    NSDictionary *unSelectedFont = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor unselected] ,NSForegroundColorAttributeName,nil];
    for(UIViewController *v in self.customizableViewControllers){
        [v.tabBarItem setTitleTextAttributes:unSelectedFont forState:UIControlStateNormal];
        [v.tabBarItem setTitleTextAttributes:selectedFont forState:UIControlStateHighlighted];
        v.tabBarItem.image = [v.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        v.tabBarItem.selectedImage = [v.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    // Do any additional setup after loading the view.
}


-(void) setViewFrames{
    _commentsTableViewFrame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - NAVBAR_HEIGHT - TABBAR_HEIGHT - 50);
    _commentFieldViewFrame = CGRectMake(0, 10 + self.view.frame.size.height - TABBAR_HEIGHT - NAVBAR_HEIGHT, self.view.frame.size.width, 100);
}



// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSLog(@"keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyboardCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:_keyboardCurve];
    _commentFieldView.frame = CGRectMake(_commentFieldViewFrame.origin.x, _commentFieldViewFrame.origin.y - _keyboardSize.height,  _commentFieldViewFrame.size.width ,  _commentFieldViewFrame.size.height);
    _commentsTableViewController.view.frame = CGRectMake(_commentsTableViewFrame.origin.x, _commentsTableViewFrame.origin.y, _commentsTableViewFrame.size.width, _commentsTableViewFrame.size.height - _keyboardSize.height);
    [UIView commitAnimations];
    
    /*
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _commentsWholeView.contentInset = contentInsets;
    _commentsWholeView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _commentField.frame.origin) ) {
        [_commentsWholeView scrollRectToVisible:_commentField.frame animated:YES];
    }*/
}



/*
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:animationCurve];
    _commentFieldView.frame = CGRectMake(0, self.view.frame.size.height - NAVBAR_HEIGHT - _keyboardSize.height - 40,  _commentFieldView.frame.size.width ,  _commentFieldView.frame.size.height);
    [UIView commitAnimations];
}*/

#pragma mark - UI methods
-(void) setTabBarItemImages{
    
    UIViewController *firstVC = [self.customizableViewControllers objectAtIndex:0];
    [firstVC.tabBarItem setImage:[UIImage imageNamed:@"home-unselected.png"]];
    [firstVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"home-selected.png"]];
    UIViewController *secondVC = [self.customizableViewControllers objectAtIndex:1];
    [secondVC.tabBarItem setImage:[UIImage imageNamed:@"explore-unselected.png"]];
    [secondVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"explore-selected.png"]];
    UIViewController *thirdVC = [self.customizableViewControllers objectAtIndex:2];
    [thirdVC.tabBarItem setImage:[UIImage imageNamed:@"user-unselected.png"]];
    [thirdVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"user-selected.png"]];
    UIViewController *fourthVC = [self.customizableViewControllers objectAtIndex:3];
    [fourthVC.tabBarItem setImage:[UIImage imageNamed:@"notif-unselected.png"]];
    [fourthVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"notif-selected.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
    NSLog(@"selectedViewController");
    if([viewController isKindOfClass:[HomeNavigationController class]]){
        HomeNavigationController *homeNavigationController = (HomeNavigationController *)viewController;
        [homeNavigationController backToRoot];
    }
    if([viewController isKindOfClass:[ProfileNavigationController class]]){
        ProfileNavigationController *profileNavigationController = (ProfileNavigationController *)viewController;
        [profileNavigationController setSelf];
        [profileNavigationController backToRoot];
        NSLog(@"sent Iru Wang");
    }
    //    if([viewController isKindOfClass:MyPostsViewController.class]){
    //        //dont add it in here, add it in my post
    //        //self.navigationItem.rightBarButtonItem = _settingBtn;
    //        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, WIDTH, NAVIGATION_BAR_CUT_DOWN_HEIGHT)];
    //    }
    //    else{
    //        self.navigationItem.rightBarButtonItem = NULL;
    //        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, NAVIGATION_BAR_CUT_DOWN_HEIGHT, NAVIGATION_BAR_CUT_DOWN_HEIGHT)];
    //    }
}

-(void) marbleButtonClicked{
    if(_isCreatingMarble){
        [_createQuizWholeView removeFromSuperview];
        _isCreatingMarble = FALSE;
    } else{
        [self.view addSubview:_createQuizWholeView];
        _isCreatingMarble = TRUE;
    }
}

-(void) viewMoreComments:(NSArray *)commentArray atIndexPath:(NSIndexPath *)indexPath calledBy:(id)viewController{
    _commentIndexPath = indexPath;
    _callerViewController = viewController;
    _commentFieldView.frame = _commentFieldViewFrame;
    _commentsTableViewController.view.frame = _commentsTableViewFrame;
    [_commentsTableViewController setCommentArray:commentArray];
    [self.view addSubview:_commentsWholeView];
}

-(void) updateComments:(NSArray *)commentArray{
    [_commentsTableViewController setCommentArray:commentArray];
}

-(void)initCreateQuizView{
    UIView *blackBGView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    [blackBGView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marbleButtonClicked)];
    [blackBGView addGestureRecognizer:singleTap];
    
    _createQuizViewController = [[CreateQuizViewController alloc] init];
    _createQuizViewController.delegate = self;
    _createQuizViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    _createQuizWholeView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    [_createQuizWholeView addSubview:blackBGView];
    [_createQuizWholeView addSubview:_createQuizViewController.view];

}


-(void) initCommentFieldView{
    _commentFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + self.view.frame.size.height - TABBAR_HEIGHT - NAVBAR_HEIGHT, self.view.frame.size.width, 100)];
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(260 , 0, 60, 30)];
    
    [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"send" forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentPostClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 30)];
    _commentField.delegate = self;
    [_commentField setBorderStyle:UITextBorderStyleRoundedRect];
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:COMMENT_TEXT attributes:[Utility getWriteACommentFontDictionary]];
    [_commentField setAttributedText:defaultText];
    [_commentFieldView addSubview:_commentField];
    [_commentFieldView addSubview:_commentBtn];
    
}

-(void)initCommentsTableView{
    [self initCommentFieldView];
    
    UIView *blackBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + KEYBOARD_HEIGHT)];
    [blackBGView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 10, 50, 50)];
    [_cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelCommentsTableView) forControlEvents:UIControlEventTouchUpInside];
    _commentsTableViewController = [[CommentsTableViewController alloc] init];
//    _commentsTableViewController.delegate = self;
    _commentsTableViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - NAVBAR_HEIGHT - TABBAR_HEIGHT - 50);
    _commentsTableViewController.delegate = self;
    _commentsWholeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height + KEYBOARD_HEIGHT)];
    [_commentsWholeView addSubview:blackBGView];
    [_commentsWholeView addSubview:_cancelButton];
    [_commentsWholeView addSubview:_commentsTableViewController.view];
    [_commentsWholeView addSubview:_commentFieldView];
}

-(void) commentPostClicked:(id)sender{
    if([_callerViewController isKindOfClass:[PostsViewController class]]){
        PostsViewController *postsViewController = _callerViewController;
        [postsViewController commentPostAtIndexPath:_commentIndexPath withComment:[_commentField text]];
    }
}


-(void)cancelCommentsTableView{
    [_commentsWholeView removeFromSuperview];
}

-(void) prepareSelectPeopleViewController{
    _selectPeopleViewController = [[SelectPeopleViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectPeopleViewController.view.frame = CGRectMake(0, 150, self.view.bounds.size.width, 200);
    _selectPeopleViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectPeopleViewController.delegate = self;
    [_createQuizWholeView addSubview:_selectPeopleViewController.view];
}

-(void) prepareSelectKeywordViewController{
    _selectKeywordViewController = [[SelectKeywordViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectKeywordViewController.view.frame = CGRectMake(0, 150, self.view.bounds.size.width, 200);
    _selectKeywordViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectKeywordViewController.delegate = self;
    [_createQuizWholeView addSubview:_selectKeywordViewController.view];
}


#pragma mark -
#pragma mark CreateQuizViewController Delegate Methods
- (void)shouldDisplayPeople:(CreateQuizViewController *)viewController withPeople:(NSArray *)people{
    [self prepareSelectPeopleViewController];
    //    [_selectPeopleViewController setPeopleArray:people];
    //    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 50,
    //                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

- (void)shouldDisplayKeywords:(CreateQuizViewController *)viewController withKeywords:(NSArray *)keywords{
    [self prepareSelectKeywordViewController];
    //    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 50,
    //                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
}

- (void)backToNormal:(CreateQuizViewController *)viewController{
    for(id view in _createQuizWholeView.subviews){
        if([view tag] == AUTO_COMPLETE_SELECT_VIEW_TAG){
            [view removeFromSuperview];
        }
    }
    //    NSLog(@"backtonormal");
    //    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 65,
    //                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

- (void)gotSearchUsersResult:(NSArray *)arrayOfUsers{
    [_selectPeopleViewController displaySearchResult:arrayOfUsers];
}

- (void)gotSearchKeywordsResult:(NSArray *)arrayOfKeywords{
    [_selectKeywordViewController displaySearchResult:arrayOfKeywords];
}

#pragma mark -
#pragma mark SelectPeopleViewController Delegate Methods
- (void)selectedPerson:(User *)user{
    [_createQuizViewController setUser:user];
}


#pragma mark -
#pragma mark SelectKeywordViewController Delegate Methods
- (void)selectedKeyword:(NSString *)keyword{
    NSLog(@"tabbar got selected");
    [_createQuizViewController setKeyword:keyword];
}

#pragma mark -
#pragma mark UITextField Delegate Methods



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setText:@""];
    
//    if(_delegate && [_delegate respondsToSelector:@selector(presentCellWithKeywordOn:)]){
//        [_delegate presentCellWithKeywordOn:textField];
//    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [textField setText:COMMENT_TEXT];
//    if(_delegate && [_delegate respondsToSelector:@selector(endPresentingCellWithKeywordOn)]){
//        [_delegate endPresentingCellWithKeywordOn];
//    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:_keyboardCurve];
    _commentFieldView.frame = _commentFieldViewFrame;
    _commentsTableViewController.view.frame = _commentsTableViewFrame;
    [UIView commitAnimations];
    return YES;
}
 
#pragma mark -
#pragma mark CommentsTableView Delegate Methods
-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid{
    [_commentsWholeView removeFromSuperview];
    if([_callerViewController isKindOfClass:[PostsViewController class]]){
        PostsViewController *postsViewController = _callerViewController;
        [postsViewController gotoProfileWithName:name andID:fbid];
    }

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
