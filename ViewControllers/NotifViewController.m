//
//  NotifViewController.m
//  Marble
//
//  Created by Albert Shih on 10/7/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "NotifViewController.h"
#import "KeywordUpdate.h"
#import "Quiz.h"
#import "CommentNotification.h"
#import "NotificationTableViewCell.h"

@interface NotifViewController ()

@property(nonatomic, strong) NSMutableArray *notifications;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userFBID;

@end

@implementation NotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbarTitle];
    _notifications = [[NSMutableArray alloc] init];
    [self fetchNotifcations];
    
    // Do any additional setup after loading the view.
}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [[myNavBar topItem] setTitle:@"NOTIFICATIONS"];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleOrange]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleOrange]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) fetchNotifcations{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults){
        _userName = [standardUserDefaults objectForKey:@"userName"];
        _userFBID = [standardUserDefaults objectForKey:@"userFBID"];
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"KeywordUpdate"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"fbID == %@", _userFBID]];

    [self fetch:request andAddToNotifications:_notifications];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Quiz"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"option0 == %@ OR option1 == %@", _userFBID, _userFBID]];
    
    [self fetch:request andAddToNotifications:_notifications];

    request = [[NSFetchRequest alloc] initWithEntityName:@"CommentNotification"];

    [self fetch:request andAddToNotifications:_notifications];
    [@"Fetched Notfication coming: %@", _notifications];
    [self.tableView reloadData];
}

- (void) fetch:(NSFetchRequest *)request andAddToNotifications:(NSMutableArray *)notifications{
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    // Execute the fetch.
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    [notifications addObjectsFromArray:matches];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_notifications count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    User *personSelected = [_notifications objectAtIndex:indexPath.row];
//    if(_delegate && [_delegate respondsToSelector:@selector(selectedPerson:)]){
//        [_delegate selectedPerson:personSelected];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
    id post = [_notifications objectAtIndex:indexPath.row];
    if([post isKindOfClass:[KeywordUpdate class]]){
        cell.type = MBKeyword;
    } else if ([post isKindOfClass:[Quiz class]]) {
        cell.type = MBQuiz;
    } else if ([post isKindOfClass:[CommentNotification class]]) {
        cell.type = MBCommentNotification;
    } else {
        MBError(@"Error here");
    }
    
    MBDebug(@"cell type: %lu", cell.type);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
