//
//  PostsViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "PostsViewController.h"
#import "QuizTableViewCell.h"

#import "Quiz.h"

#import "KeyChainWrapper.h"

@interface PostsViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation PostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _postArray = [NSArray arrayWithObjects:@"Peanut",@"Wen Shaw",  nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Load quizzes from the server
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[sessionToken] forKeys:@[@"auth_token"]];
    [[RKObjectManager sharedManager] getObject:[Quiz alloc]
                                          path:nil
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           MBDebug(@"Successfully loadded quizzes");
                                           MBDebug(@"%ld quiz(zes) were loaded.", [[mappingResult array] count]);
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{MBError(@"Cannot load quizzes");}]
     ];
    
    //set up fetched results controller
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Quiz"];
//    if (predicate) request.predicate = predicate;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"keyword" ascending:YES];
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
    NSString *quizTableViewCellIdentifier = @"quizTableViewCellIdentifier";
    QuizTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:quizTableViewCellIdentifier];
    Quiz *quiz = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if (!cell){
        cell = [[QuizTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:quizTableViewCellIdentifier];
    }

    [cell setQuizWithAuthor:quiz.authorName andOption0:quiz.option0Name andOption1:quiz.option1Name andKeyword:quiz.keyword];
//    NSLog(@"%@", quiz);
    [cell.option0NameButton setTag:indexPath.row];
    [cell.option1NameButton setTag:indexPath.row];
    [cell.authorNameButton setTag:indexPath.row];
    [cell.option0NameButton addTarget:self action:@selector(option0Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.option1NameButton addTarget:self action:@selector(option1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.authorNameButton addTarget:self action:@selector(authorClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.quizUUID = quiz.uuid;
    return cell;
}

-(void)option0Clicked:(id)sender{
    NSLog(@"option0clicked");
    NSIndexPath *path;
    if ([sender tag]) {
        path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    } else{
        path = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    Quiz *quiz = [_fetchedResultsController objectAtIndexPath:path];
    NSString *personSelected = quiz.option0Name;
    if(_delegate && [_delegate respondsToSelector:@selector(postSelected:)]){
        [_delegate postSelected:personSelected];
    }
}

-(void)option1Clicked:(id)sender{
    NSLog(@"option1clicked");
    NSIndexPath *path;
    if ([sender tag]) {
        path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    } else{
        path = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    Quiz *quiz = [_fetchedResultsController objectAtIndexPath:path];
    NSString *personSelected = quiz.option1Name;
    if(_delegate && [_delegate respondsToSelector:@selector(postSelected:)]){
        [_delegate postSelected:personSelected];
    }
}

-(void)authorClicked:(id)sender{
    NSIndexPath *path;
    if ([sender tag]) {
        path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    } else{
        path = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    NSLog(@"tag %d",[sender tag]);
    Quiz *quiz = [_fetchedResultsController objectAtIndexPath:path];
    NSString *personSelected = quiz.authorName;
    if(_delegate && [_delegate respondsToSelector:@selector(postSelected:)]){
        [_delegate postSelected:personSelected];
    }
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
    return 120;
}

#pragma mark -
#pragma mark Quiz Table View Cell Delegate Methods
- (void) commentQuiz:(id)sender withComment:(NSString *)comment
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Quiz *quiz = [_fetchedResultsController objectAtIndexPath:indexPath];

    MBDebug(@"%@", comment);
    MBDebug(@"%@", quiz.uuid);
    
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[quiz.uuid, comment, [KeyChainWrapper getSessionTokenForUser]]
                                   forKeys:@[@"quiz_uuid", @"comment", @"auth_token"]];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:@"send_comment"
                                                                                          object:self
                                                                                      parameters:params];
    
    RKHTTPRequestOperation *operation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        MBDebug(@"Comment posted");
        NSMutableArray *comments;
        if (quiz.comments == nil) {
            comments = [NSMutableArray arrayWithArray:quiz.comments];
        } else {
            comments = [[NSMutableArray alloc] init];
        }
        [comments addObject:@[@"me", comment]];
        quiz.comments = comments;
//        MBDebug(@"comments: %@", quiz.comments);
        [self getCommentsForQuiz:quiz];
    }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [Utility generateAlertWithMessage:@"Network problem"];
                                         });
                                         MBError(@"Cannot send comment!");
                                     }];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

- (void)getCommentsForQuiz:(Quiz *)quiz
{
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[quiz.uuid, sessionToken] forKeys:@[@"quiz_uuid", @"auth_token"]];

    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"get_comments" object:quiz parameters:params
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            MBDebug(@"Returned comments");
            MBDebug(@"Quiz author: %@", quiz.author);
            MBDebug(@"Quiz keyword: %@", quiz.keyword);
            for (NSDictionary *cmt in quiz.comments) {
                MBDebug(@"fb_id: %@, comment: %@", [cmt valueForKey:@"fb_id"], [cmt valueForKey:@"comment"]);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
