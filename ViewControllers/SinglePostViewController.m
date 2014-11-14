//
//  SinglePostViewController.m
//  Marble
//
//  Created by Iru on 10/28/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "SinglePostViewController.h"
#import "QuizTableViewCell.h"
#import "StatusUpdateTableViewCell.h"
#import "KeywordUpdateTableViewCell.h"
#import "CommentNotification.h"
#import "PostsTableViewSuperCell.h"
#import "Post+MBPost.h"

@interface SinglePostViewController()
@property (strong, nonatomic) Post *mustBePost;
@property (strong, nonatomic) id postWithoutClass;
@property (strong, nonatomic) PostsTableViewSuperCell *cell;
@end

@implementation SinglePostViewController

-(void)viewDidLoad{
//    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor marbleBackGroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    

}

-(void) viewWillAppear:(BOOL)animated{
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCellType cellType;
    if ([_mustBePost isKindOfClass:[Quiz class]]){
        cellType = MBQuizCellType;
    } else if([_mustBePost isKindOfClass:[StatusUpdate class]]){
        cellType = MBStatusUpdateCellType;
    } else if([_mustBePost isKindOfClass:[KeywordUpdate class]]){
        cellType = MBKeywordUpdateCellType;
    } else {
        MBDebug(@"Should never happen");
    }
    return [Utility getCellHeightForPostWithType:cellType withComments:_mustBePost.comments whetherSinglePost:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_postWithoutClass isKindOfClass:[CommentNotification class]]) {
        QuizTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:quizTableViewCellIdentifier];
        if (!cell){
            cell = [[QuizTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:quizTableViewCellIdentifier];
        }
        if(_mustBePost){
            [cell setQuiz:(Quiz *)_mustBePost];
        }
        cell.delegate = self;
        _cell = cell;
        if(_mustBePost.comments){
            [_cell setCommentsForPostSuperCell:_mustBePost.comments];
        }
        return cell;
    }
    
    if ([_mustBePost isKindOfClass:[Quiz class]]){
        Quiz *quiz = (Quiz *)_mustBePost;
        QuizTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:quizTableViewCellIdentifier];
        if (!cell){
            cell = [[QuizTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singlePostQuizTableViewCellIdentifier];
        }
        
        [cell setQuiz:(Quiz *)quiz];
        cell.delegate = self;
        
        cell.quizUUID = quiz.uuid;
        _cell = cell;
    } else if ([_mustBePost isKindOfClass:[StatusUpdate class]]) {
        StatusUpdate *status = (StatusUpdate *)_mustBePost;
        StatusUpdateTableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:singlePostStatusTableViewCellIdentifier];
        if (!cell){
            cell = [[StatusUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singlePostStatusTableViewCellIdentifier];
        }
        cell.delegate = self;
        [cell setStatusUpdate:status];
        //        MBDebug(@"status cell: %@", cell);
        MBDebug(@"status update: %@", status);
        _cell = cell;
    } else {
        KeywordUpdate *keywordUpdate = (KeywordUpdate *)_mustBePost;
        KeywordUpdateTableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:singlePostKeywordUpdateTableViewCellIdentifier];
        if (!cell){
            cell = [[KeywordUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singlePostKeywordUpdateTableViewCellIdentifier];
        }
        [cell setKeywordUpdate:keywordUpdate];
        MBDebug(@"keyword update: %@", keywordUpdate);
        cell.delegate = self;
        //if keyword comment ready, uncomment

        _cell = cell;
    }
    
    if(_mustBePost.comments){
        [_cell setCommentsForPostSuperCell:_mustBePost.comments];
    }
    return _cell;
    
}


//Overwrite PostsViewController Methods
- (void) sendGuess:(id)sender withAnswer:(NSString *)answer{
    Quiz *quiz = (Quiz *)_mustBePost;
    [super sendGuessForQuiz:quiz andAnswer:answer];
}
- (void) commentPost:(id)sender withComment:(NSString *)comment{
    [super commentPostForPost:_mustBePost withComment:comment];
}


-(void)setSinglePost:(id)post{
    _postWithoutClass = post;
    if(![_postWithoutClass isKindOfClass:[CommentNotification class]]){
        _mustBePost = post;
        [self getCommentsForPost:_mustBePost];
    } else {
        __weak PostsViewController *weakSelf = self;
        CommentNotification *object = (CommentNotification *)_postWithoutClass;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"uuid = %@", object.postUUID]];
        NSArray *match = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:nil];
        
        if ([match count] > 1) {
            MBError(@"ERROR: there are two posts that have the same uuid %@", object.postUUID);
        } else if ([match count] == 1) {
            _mustBePost = [match firstObject];
            _postWithoutClass = nil;
            MBDebug(@"Found the single post: %@", _mustBePost);
            if(_mustBePost.comments){
                [_cell setCommentsForPostSuperCell:_mustBePost.comments];
            }
//            else{
//                [self getCommentsForPost:_mustBePost];
//            }
            [self.tableView reloadData];
        }
//        else {
            NSMutableDictionary *params = [weakSelf generateBasicParams];
            [params setValue:object.postUUID forKey:@"post_uuid"];
            [[RKObjectManager sharedManager] getObject:[Post alloc]
                                                  path:nil
                                            parameters:params
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   for (Post *post in [mappingResult array]) {
                                                       [post initParentAttributes];
                                                       _mustBePost = post;
                                                   }
                                                   [Post setIndicesAsLoadingMore:[mappingResult array]];

                                                   
                                                   [Utility saveToPersistenceStore:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext failureMessage:@"failed to save."];
                                                   MBDebug(@"Fetched single post: %@", _mustBePost);
                                                   _postWithoutClass = nil;
                                                   [self getCommentsForPost:_mustBePost];
                                                   [self.tableView reloadData];
                                               }
                                               failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                                       block:^{
                                                                                           MBError(@"Cannot load updates");}]
             ];
//        }
    }
}



- (void)getCommentsForPost:(Post *)post{
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[post.uuid, sessionToken] forKeys:@[@"post_uuid", @"auth_token"]];
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"get_comments" object:post parameters:params
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
           MBDebug(@"Returned comments");
           for (NSDictionary *cmt in post.comments) {
               MBDebug(@"fb_id: %@, comment: %@", [cmt valueForKey:@"fb_id"], [cmt valueForKey:@"comment"]);
           }
           
            [_cell setCommentsForPostSuperCell:post.comments];
            [self.tableView reloadData];
           
       }
       failure:^(RKObjectRequestOperation *operation, NSError *error) {
           [Utility generateAlertWithMessage:@"Network problem"];
           MBError(@"Cannot get comments!");
       }];
}

@end
