//
//  MarbleTabBarController.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "MarbleTabBarController.h"
#import "ExploreNavigationController.h"
#import "ProfileNavigationController.h"
#import "HomeNavigationController.h"
#import "CommentsTableViewController.h"
#import "PostsViewController.h"

#import "DAKeyboardControl.h"

#define COMMENT_TEXT @"write a comment..."

@interface MarbleTabBarController ()
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
@property (strong, nonatomic) Post *commentingOnPost;
@property (nonatomic) NSUInteger commentNum;
@end

@implementation MarbleTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewFrames];
//    [self initCreateQuizView];
    [self initCommentsTableView];
    [self registerForKeyboardNotifications];
    self.delegate = self;
    _isCreatingMarble = FALSE;

    //HYJ
    [self initKeyboardDismiss];
    
    //set tabbaritem image
    [self setTabBarItemImages];
    // set tabbaritem font
    NSDictionary *selectedFont = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:11],NSFontAttributeName, [UIColor marbleOrange] ,NSForegroundColorAttributeName,nil];
    NSDictionary *unSelectedFont = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:11],NSFontAttributeName, [UIColor unselected] ,NSForegroundColorAttributeName,nil];
    for(UIViewController *v in self.customizableViewControllers){
        [v.tabBarItem setTitleTextAttributes:unSelectedFont forState:UIControlStateNormal];
        [v.tabBarItem setTitleTextAttributes:selectedFont forState:UIControlStateHighlighted];
        v.tabBarItem.image = [v.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        v.tabBarItem.selectedImage = [v.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    // Do any additional setup after loading the view.

    if ([UIApplication sharedApplication].applicationIconBadgeNumber == 0) {
        [[[[self tabBar] items] lastObject] setBadgeValue:nil];
    } else {
        NSString *badgeValue = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
        [[[[self tabBar] items] lastObject] setBadgeValue:badgeValue];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self addCenterButtonWithImage:[UIImage imageNamed:MARBLE_IMAGE_NAME] highlightImage:nil];
}
#pragma mark - add center button
-(void)willAppearIn:(UINavigationController *)navigationController
{

    
}
// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    int buttonWidth = 60;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonWidth);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(centerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    button.adjustsImageWhenHighlighted = NO;
    
    CGFloat heightDifference = buttonWidth - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
    
    //disable dummy tabbar item
    NSArray *tabItems = self.tabBar.items;
    [[tabItems objectAtIndex:2] setEnabled:NO];
}
#pragma mark - center button function
-(void)centerButtonTap:(id)sender{
    [self performSegueWithIdentifier:@"CreateQuizViewControllerSegue" sender:sender];
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
    //HYJ
//    _commentFieldView.frame = CGRectMake(_commentFieldViewFrame.origin.x, _commentFieldViewFrame.origin.y - _keyboardSize.height,  _commentFieldViewFrame.size.width ,  _commentFieldViewFrame.size.height);
//    _commentsTableViewController.view.frame = CGRectMake(_commentsTableViewFrame.origin.x, _commentsTableViewFrame.origin.y, _commentsTableViewFrame.size.width, _commentsTableViewFrame.size.height - _keyboardSize.height);
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
    UIViewController *thirdVC = [self.customizableViewControllers objectAtIndex:3];
    [thirdVC.tabBarItem setImage:[UIImage imageNamed:@"user-unselected.png"]];
    [thirdVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"user-selected.png"]];
    UIViewController *fourthVC = [self.customizableViewControllers objectAtIndex:4];
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
    } else if([viewController isKindOfClass:[ProfileNavigationController class]]){
        ProfileNavigationController *profileNavigationController = (ProfileNavigationController *)viewController;
        [profileNavigationController setSelf];
        [profileNavigationController backToRoot];
//        NSLog(@"sent Iru Wang");
    } else if([viewController isKindOfClass:[ExploreNavigationController class]]){
        ExploreNavigationController *exploreNavigationController = (ExploreNavigationController *)viewController;
        [exploreNavigationController backToRoot];
//        NSLog(@"sent Iru Wang");
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

-(void) marbleButtonClickedWithUser:(User *)user orKeyword:(NSString *)keyword{
    /*
    if(_isCreatingMarble){
        [_createQuizWholeView removeFromSuperview];
        _isCreatingMarble = FALSE;
        return;
    }
    [_createQuizViewController setOption0Option1];
    if(user){
        [_createQuizViewController setOption0:user];
    } else if(keyword){
        NSLog(@"tabbarset keyword %@", keyword);
        [_createQuizViewController setKeyword:keyword];
    } else{
        [_createQuizViewController resetAllOptions];
    }
    [self.view addSubview:_createQuizWholeView];
    _isCreatingMarble = TRUE;
     */
}

-(void) viewMoreComments:(NSArray *)commentArray forPost:(Post *)post calledBy:(id)viewController{
    _commentingOnPost = post;
    _callerViewController = viewController;
    _commentFieldView.frame = _commentFieldViewFrame;
    _commentsTableViewController.view.frame = _commentsTableViewFrame;
    [_commentsTableViewController setCommentArray:commentArray];
    [self.view addSubview:_commentsWholeView];
    
    //HYJ
    // adjust keyboard trigger offset
//    self.view.keyboardTriggerOffset = _commentFieldViewFrame.size.height-TABBAR_HEIGHT;

}

-(void) updateComments:(NSArray *)commentArray{
    [_commentsTableViewController setCommentArray:commentArray];
    
    //HYJ
    // auto scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, _commentsTableViewController.tableView.contentSize.height - _commentsTableViewController.tableView.bounds.size.height + _keyboardSize.height);
    [_commentsTableViewController.tableView setContentOffset:bottomOffset animated:YES];

}


-(void)closeMarbleWholeView{
    [_createQuizWholeView removeFromSuperview];
    _isCreatingMarble = FALSE;
}


-(void) initCommentFieldView{
    _commentFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + self.view.frame.size.height - TABBAR_HEIGHT - NAVBAR_HEIGHT, self.view.frame.size.width, 100)];
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(270 , -2, 35, 35)];
    
    [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:@"send-no-border.png"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentPostClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 30)];
    _commentField.delegate = self;
    [_commentField setBorderStyle:UITextBorderStyleRoundedRect];
    _commentField.returnKeyType = UIReturnKeySend;
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

//HYJ
-(void)initKeyboardDismiss
{
    self.view.keyboardTriggerOffset = 0;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect accessoryViewFrame = _commentFieldView.frame;
        accessoryViewFrame.origin.y = keyboardFrameInView.origin.y - accessoryViewFrame.size.height - 5;
        _commentFieldView.frame = accessoryViewFrame;
        
    } constraintBasedActionHandler:nil];
    //[self.view removeKeyboardControl];
}


-(void) commentPostClicked:(id)sender{
    if([[_commentField text] isEqualToString:@""]){
        return;
    }
    if([_callerViewController isKindOfClass:[PostsViewController class]]){
        PostsViewController *postsViewController = _callerViewController;
        [postsViewController commentPostForPost:_commentingOnPost withComment:[_commentField text]];
    }
    [_commentField setText:@""];
}


-(void)cancelCommentsTableView{
    [_commentsWholeView removeFromSuperview];
    
    //HYJ
    // adjust keyboard trigger offset
    self.view.keyboardTriggerOffset = 0;
}




#pragma mark -
#pragma mark CreateQuizViewController Delegate Methods
- (void)shouldDisplayPeople:(CreateQuizViewController *)viewController withPeople:(NSArray *)people{
    //    [_selectPeopleViewController setPeopleArray:people];
    //    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 50,
    //                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

- (void)shouldDisplayKeywords:(CreateQuizViewController *)viewController withKeywords:(NSArray *)keywords{
    //    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 50,
    //                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
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
    [textField setText:COMMENT_TEXT];
//    if(_delegate && [_delegate respondsToSelector:@selector(endPresentingCellWithKeywordOn)]){
//        [_delegate endPresentingCellWithKeywordOn];
//    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self commentPostClicked:textField];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.25];
//    [UIView setAnimationCurve:_keyboardCurve];
//    _commentFieldView.frame = _commentFieldViewFrame;
//    _commentsTableViewController.view.frame = _commentsTableViewFrame;
//    [UIView commitAnimations];
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isKindOfClass:[CreateQuizViewController class]]){
        CreateQuizViewController *vc = (CreateQuizViewController *)[segue destinationViewController];
        vc.delegate = self;
        vc.lookingAtEitherUserOrKeyword = _lookingAtEitherUserOrKeyword;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
