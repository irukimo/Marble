//
//  PostsViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "SVPullToRefresh.h"

#import "PostsViewController.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "KeywordProfileViewController.h"

#import "QuizTableViewCell.h"
#import "StatusUpdateTableViewCell.h"
#import "KeywordUpdateTableViewCell.h"
#import "MarbleTabBarController.h"

#import "NSNumber+MBNumber.h"

#import "User+MBUser.h"
#import "Quiz.h"
#import "Quiz+MBQuiz.h"
#import "Post.h"
#import "Post+MBPost.h"
#import "StatusUpdate.h"
#import "KeywordUpdate.h"


#import "PostsTableViewSuperCell.h"

@interface PostsViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
    @property (strong, nonatomic) NSNumber *numOfPagesOfQuizzes;
    @property (strong, nonatomic) NSNumber *numOfPagesOfUpdates;
@end

@implementation PostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor marbleLightGray]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // initialize num pages
    self.numOfPagesOfQuizzes = [NSNumber numberWithInt:1]; // page number starts from 1
    self.numOfPagesOfUpdates = [NSNumber numberWithInt:1];
    
    // Load quizzes from the server
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[sessionToken, _numOfPagesOfQuizzes] forKeys:@[@"auth_token", @"page"]];
    [[RKObjectManager sharedManager] getObject:[Quiz alloc]
                                          path:nil
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           _numOfPagesOfQuizzes = [_numOfPagesOfQuizzes increment];
                                           MBDebug(@"Successfully loadded quizzes");
                                           MBDebug(@"%ld quiz(zes) were loaded.", [[mappingResult array] count]);
                                           for (Quiz *quiz in [mappingResult array]) {
                                               [quiz initFBIDs];
                                               MBDebug(@"quiz compare num: %@", quiz.compareNum);
                                               MBDebug(@"quiz time: %@", quiz.time);
                                               MBDebug(@"quiz show time: %@", [Utility getDateToShow:quiz.time inWhole:NO]);
                                               MBDebug(@"quiz show time: %@", [Utility getDateToShow:quiz.time inWhole:YES]);
                                           }
                                           [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:@"failed to save."];
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{MBError(@"Cannot load quizzes");}]
     ];
    
    //Load updates from the server
    params = [NSDictionary dictionaryWithObjects:@[sessionToken, _numOfPagesOfUpdates] forKeys:@[@"auth_token", @"page"]];
    [[RKObjectManager sharedManager] getObject:[Post alloc]
                                          path:nil
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           _numOfPagesOfUpdates = [_numOfPagesOfUpdates increment];
                                           MBDebug(@"Successfully loadded posts");
                                           MBDebug(@"%ld post(s) were loaded.", [[mappingResult array] count]);
                                           
                                           for (Post *post in [mappingResult array]) {
                                               [post initFBIDs];
//                                               if ([post isKindOfClass:[StatusUpdate class]]){
//                                                   MBDebug(@"status update: %@", (StatusUpdate *)post);
//                                               } else if ([post isKindOfClass:[KeywordUpdate class]]) {
//                                                  MBDebug(@"keyword update: %@", (KeywordUpdate *)post);
//                                               }
                                           }
                                           [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:@"failed to save."];
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{MBError(@"Cannot load posts");}]
     ];

    
    //set up fetched results controller
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
//    if(_predicate != nil) {
//        [request setPredicate:_predicate];
//        
//    }
//    MBDebug(@"predicate: %@", _predicate);
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"popularity" ascending:YES];
    request.sortDescriptors = @[sort];
    
    _fetchedResultsController =
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:request
     managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
     sectionNameKeyPath:nil
     cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    // Let's perform one fetch here
    NSError *fetchingErr = nil;
    if ([_fetchedResultsController performFetch:&fetchingErr]){
        NSLog(@"Successfully fetched.");
    } else {
        NSLog(@"Failed to fetch");
    }
    
    [self setMyTableView];
    self.tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeInteractive;
    [self addMarbleButton];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
<<<<<<< HEAD

    
    __weak PostsViewController *weakSelf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        MBDebug(@"Called infinite scrolling");
        // append data to data source, insert new cells at the end of table view
        // call [tableView.infiniteScrollingView stopAnimating] when done
        [weakSelf startLoadingMore];
    }];
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        MBDebug(@"Called pull to refreshing");
        [weakSelf startRefreshing];
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    }];

    self.tableView.contentInset =  UIEdgeInsetsMake(5, 0, 5, 0);
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void) addMarbleButton{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle: @"+"
                                    style: UIBarButtonItemStyleBordered
                                    target:self action: @selector(marbleButtonClicked:)];
    
    [self.navigationItem setRightBarButtonItem:rightButton];
}

-(void) marbleButtonClicked:(id)sender{
    if([self.tabBarController isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *tabbarcontroller = (MarbleTabBarController *)self.tabBarController;
        if([self isKindOfClass:[HomeViewController class]]){
            [tabbarcontroller marbleButtonClickedWithUser:nil orKeyword:nil];
        } else if([self isKindOfClass:[ProfileViewController class]]){
            ProfileViewController *profileVC = (ProfileViewController *)self;
            [tabbarcontroller marbleButtonClickedWithUser:profileVC.user orKeyword:nil];
        } else if([self isKindOfClass:[KeywordProfileViewController class]]){
            KeywordProfileViewController *keywordProfileVC = (KeywordProfileViewController *)self;
            [tabbarcontroller marbleButtonClickedWithUser:nil orKeyword:keywordProfileVC.keyword];
            NSLog(@"set keyword %@", keywordProfileVC.keyword);
        } else{
            NSLog(@"should never happen");
        }
    }
}


-(void) setMyTableView{
//    self.refreshControl = [UIRefreshControl new];
//    [self.refreshControl addTarget:self action:@selector(startRefreshing) forControlEvents:UIControlEventValueChanged];
}

- (void) startLoadingMore {
    __weak PostsViewController *weakSelf = self;
    
    NSMutableDictionary *params = [weakSelf generateBasicParams];
    [params setObject:_numOfPagesOfQuizzes forKey:@"page"];
    [[RKObjectManager sharedManager] getObject:[Quiz alloc]
                                          path:nil
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           _numOfPagesOfQuizzes = [_numOfPagesOfQuizzes increment];
                                           MBDebug(@"# of pages of quizzes: %@", _numOfPagesOfQuizzes);
                                           MBDebug(@"Refreshing: %ld quiz(zes) were successfully loaded.", [[mappingResult array] count]);
                                           [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:@"failed to save."];
                                           
                                           [weakSelf.tableView.pullToRefreshView stopAnimating];
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{
                                                                                   [weakSelf.tableView.pullToRefreshView stopAnimating];
                                                                                   MBError(@"Cannot load quizzes");}]
     ];
    
    [params setObject:_numOfPagesOfUpdates forKey:@"page"];
    [[RKObjectManager sharedManager] getObject:[Post alloc]
                                          path:nil
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           _numOfPagesOfUpdates = [_numOfPagesOfUpdates increment];
                                           MBDebug(@"# of pages of updates: %@", _numOfPagesOfUpdates);
                                           for (Post *post in [mappingResult array]) {
                                               [post initFBIDs];
                                           }
                                           [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:@"failed to save."];
                                           
                                           [weakSelf.tableView.pullToRefreshView stopAnimating];
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{
                                                                                   [weakSelf.tableView.pullToRefreshView stopAnimating];
                                                                                   MBError(@"Cannot load updates");}]
     ];
    
    
    [weakSelf.tableView.infiniteScrollingView stopAnimating];
}

-(void) startRefreshing{
    [self startRefreshing:[self generateBasicParams]];
}

- (NSMutableDictionary *)generateBasicParams{
    // check if seesion token is valid
    if (![KeyChainWrapper isSessionTokenValid]) {
        NSLog(@"User session token is not valid. Stop refreshing up");
        [self.tableView.pullToRefreshView stopAnimating];
        return nil;
    }
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    
    return [NSMutableDictionary dictionaryWithObjects:@[sessionToken]
                                              forKeys:@[@"auth_token"]];

//    return [NSMutableDictionary dictionaryWithObjects:@[sessionToken, self.type]
//                                              forKeys:@[@"auth_token", @"type"]];
}

- (void) startRefreshing:(NSMutableDictionary *)params
{
    __weak PostsViewController *weakSelf = self;
    
    [params setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [[RKObjectManager sharedManager] getObject:[Quiz alloc]
                                          path:nil
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           MBDebug(@"Refreshing: %ld quiz(zes) were successfully loaded.", [[mappingResult array] count]);
                                           [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:@"failed to save."];
                                           
                                           [weakSelf.tableView.pullToRefreshView stopAnimating];
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{MBError(@"Cannot load quizzes");}]
     ];
    
    [[RKObjectManager sharedManager] getObject:[Post alloc]
                                          path:nil
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           for (Post *post in [mappingResult array]) {
                                               [post initFBIDs];
                                           }
                                           [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:@"failed to save."];
                                           
                                           [weakSelf.tableView.pullToRefreshView stopAnimating];
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{[weakSelf.tableView.pullToRefreshView stopAnimating];}]
     ];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Fetched Results Controller Delegate Methods

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}


/* Every time when a new post is created, it is first an insert at the bottom of the table view, then a move from the bottom to the top.
 * Then an update because of the context save I think.
 *
 */
- (void) controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath{
    
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView
         deleteRowsAtIndexPaths:@[indexPath]
         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeInsert) {
        [self.tableView
         insertRowsAtIndexPaths:@[newIndexPath]
         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeUpdate) {
        
        
    } else if (type == NSFetchedResultsChangeMove) {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = _fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];

    
    if ([post isKindOfClass:[Quiz class]]){
        Quiz *quiz = (Quiz *)post;
        QuizTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:quizTableViewCellIdentifier];
        if (!cell){
            cell = [[QuizTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:quizTableViewCellIdentifier];
        }
        
        [cell setQuiz:(Quiz *)quiz];
        
        MBDebug(@"quiz: %@", quiz);

        cell.delegate = self;

        cell.quizUUID = quiz.uuid;
        [self getCommentsForPost:post];
        return cell;
    } else if ([post isKindOfClass:[StatusUpdate class]]) {
        StatusUpdate *status = (StatusUpdate *)post;
        StatusUpdateTableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:statusTableViewCellIdentifier];
        if (!cell){
            cell = [[StatusUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:statusTableViewCellIdentifier];
        }
        cell.delegate = self;
        [cell setName:status.name andID:status.fbID andStatus:status.status];
//        MBDebug(@"status cell: %@", cell);
        MBDebug(@"status update: %@", status);
        [self getCommentsForPost:post];
        return cell;
    } else {
        KeywordUpdate *keywordUpdate = (KeywordUpdate *)post;
        KeywordUpdateTableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:keywordUpdateTableViewCellIdentifier];
        if (!cell){
            cell = [[KeywordUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keywordUpdateTableViewCellIdentifier];
        }
        [cell setName:keywordUpdate.name andID:keywordUpdate.fbID andKeyword: keywordUpdate.keywords];
        MBDebug(@"keyword update: %@", keywordUpdate);
        cell.delegate = self;
        //if keyword comment ready, uncomment
        [self getCommentsForPost:post];
        return cell;

    }

}



-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid{
    NSArray *infoBundle = [NSArray arrayWithObjects:name,fbid, nil];
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:infoBundle];
}

-(void) gotoKeywordProfileWithKeyword:(NSString *)keyword{
    [self performSegueWithIdentifier:@"KeywordProfileViewControllerSegue" sender:keyword];
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Quiz *quiz = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString *personSelected = quiz.authorName;
    if(_delegate && [_delegate respondsToSelector:@selector(postSelected:)]){
        [_delegate postSelected:personSelected];
    }
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([post isKindOfClass:[Quiz class]]){
        if(!post.comments){
            return QuizTableViewCellDisplayHeight;
        } else if([post.comments count] > 2){
            return QuizTableViewCellDisplayHeight + 3*CommentIncrementHeight;
        } else{
            return QuizTableViewCellDisplayHeight + [post.comments count]*CommentIncrementHeight;
        }
    } else if([post isKindOfClass:[StatusUpdate class]]){
        if(!post.comments){
            return StatusUpdateTableViewCellHeight;
        } else if([post.comments count] > 2){
            return StatusUpdateTableViewCellHeight + 3*CommentIncrementHeight;
        } else{
            return StatusUpdateTableViewCellHeight + [post.comments count]*CommentIncrementHeight;
        }
    } else{
        if(!post.comments){
            return KeywordUpdateTableViewCellHeight;
        } else if([post.comments count] > 2){
            return KeywordUpdateTableViewCellHeight + 3*CommentIncrementHeight;
        } else{
            return KeywordUpdateTableViewCellHeight + [post.comments count]*CommentIncrementHeight;
        }
    }
}

#pragma mark -
#pragma mark Posts Table View Super Cell Delegate Methods

-(void) viewMoreComments:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];
    if([self.tabBarController isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *tabbarcontroller = (MarbleTabBarController *)self.tabBarController;
        [tabbarcontroller viewMoreComments:post.comments atIndexPath:indexPath calledBy:self];
    }
}

-(void) presentCellWithKeywordOn:(id) sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.tableView.contentInset =  UIEdgeInsetsMake(5, 0, KEYBOARD_HEIGHT, 0);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
-(void) endPresentingCellWithKeywordOn{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0,  TABBAR_HEIGHT + 5, 0);
    [UIView commitAnimations];
}


- (void) sendGuess:(id)sender withAnswer:(NSString *)answer
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Quiz *quiz = [_fetchedResultsController objectAtIndexPath:indexPath];
    MBDebug(@"Answer to send with guess: %@", answer);
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[quiz.uuid, answer, [KeyChainWrapper getSessionTokenForUser]]
                                   forKeys:@[@"quiz_uuid", @"answer", @"auth_token"]];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:@"send_guess"
                                                                                          object:self
                                                                                      parameters:params];
    
    RKHTTPRequestOperation *operation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        MBDebug(@"Guess posted");
        [quiz incrementCompareNum];
        [quiz setGuessed:answer];
//        MBDebug(@"Quiz now: %@", quiz);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [Utility generateAlertWithMessage:@"Network problem"];
                                         });
                                         MBError(@"Cannot send guess!");
                                     }];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

- (void) commentPost:(id)sender withComment:(NSString *)comment
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];

    MBDebug(@"%@", comment);
    [Utility sendThroughRKRoute:@"send_comment" withParams:@{@"post_uuid": post.uuid, @"comment": comment}
                   successBlock:^{ [self getCommentsForPost:post]; }
                   failureBlock:nil];
}

- (void) commentPostAtIndexPath:(NSIndexPath *)indexPath withComment:(NSString *)comment{
    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    MBDebug(@"%@", comment);
    [Utility sendThroughRKRoute:@"send_comment" withParams:@{@"post_uuid": post.uuid, @"comment": comment}
                   successBlock:^{ [self getCommentsForPost:post]; }
                   failureBlock:nil];
}

- (void)getCommentsForPost:(Post *)post
{
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[post.uuid, sessionToken] forKeys:@[@"post_uuid", @"auth_token"]];

    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"get_comments" object:post parameters:params
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            MBDebug(@"Returned comments");
            for (NSDictionary *cmt in post.comments) {
                MBDebug(@"fb_id: %@, comment: %@", [cmt valueForKey:@"fb_id"], [cmt valueForKey:@"comment"]);
            }
            NSIndexPath *path = [_fetchedResultsController indexPathForObject:post];
            id cell = [(UITableView *)self.view cellForRowAtIndexPath:path];
            
            PostsTableViewSuperCell *superCell = (PostsTableViewSuperCell *)cell;
            [superCell setCommentsForPostSuperCell:post.comments];
            
            if([self.tabBarController isKindOfClass:[MarbleTabBarController class]]){
                MarbleTabBarController *tabbarcontroller = (MarbleTabBarController *)self.tabBarController;
                [tabbarcontroller updateComments:post.comments];
            }
            
            
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [Utility generateAlertWithMessage:@"Network problem"];
            MBError(@"Cannot get comments!");
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableView
 EditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @" "
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue destinationViewController] isKindOfClass:[ProfileViewController class]]){
        if([sender isKindOfClass:[NSArray class]]){
            ProfileViewController *viewController =[segue destinationViewController];
            [viewController setName:(NSString *)[sender firstObject] andID:[sender objectAtIndex:1] sentFromTabbar:NO];
        }
    } else if([[segue destinationViewController] isKindOfClass:[KeywordProfileViewController class]]){
        KeywordProfileViewController *viewController =[segue destinationViewController];
        [viewController setKeyword:sender];
    }
}


#pragma mark - Scroll view delegate method
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

@end
