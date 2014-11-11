//
//  LoginViewController.m
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "User+MBUser.h"
#import "dispatch/semaphore.h"
#import "PageContentViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSString *userName;
@property dispatch_semaphore_t mysemaphore;
    
@property (strong, nonatomic) NSArray *fbEngUsers;
@property (strong, nonatomic) NSArray *fbChUsers;

//for walkthrough
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //for walkthrough
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 70);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    //
    
    /*
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [backgroundView setImage:[UIImage imageNamed:@"login.png"]];
    [self.view addSubview:backgroundView];
     */
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]]];
    // Do any additional setup after loading the view.
    
    //its delegate will automatically be set to launchviewcontroller
    _loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    // Align the button in the center horizontally
    _loginView.frame = CGRectOffset(_loginView.frame, (self.view.center.x - (_loginView.frame.size.width / 2)), 500);
    [self.view addSubview:_loginView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//functions for walkthrough

- (IBAction)startWalkthrough:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end
