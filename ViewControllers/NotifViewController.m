//
//  NotifViewController.m
//  Marble
//
//  Created by Albert Shih on 10/7/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "NotifViewController.h"
#import "NotificationTableViewCell.h"
#import "KeyChainWrapper.h"
#import "ClientManager.h"
#import "SinglePostViewController.h"

@interface NotifViewController ()

@property(nonatomic, strong) NSMutableArray *notifications;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userFBID;

@end

@implementation NotifViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[[KeyChainWrapper getSessionTokenForUser]]
                                   forKeys:@[@"auth_token"]];
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"get_notifications"
                                                            object:self
                                                        parameters:params
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               MBDebug(@"GET notification: %@", mappingResult);
               [self fetchNotifcations];
               [ClientManager sendBadgeNumber:0];
               [[[[self.tabBarController tabBar] items] lastObject] setBadgeValue:nil];
           }
           failure:^(RKObjectRequestOperation *operation, NSError *error) {
               [Utility generateAlertWithMessage:@"Network problem"];
               MBError(@"Cannot get notifications!");
           }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbarTitle];
    _notifications = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [myNavBar setTitleTextAttributes:[Utility getNavigationBarTitleFontDictionary]];
    [[myNavBar topItem] setTitle:@"通知"];
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
    _userName = [KeyChainWrapper getSelfName];
    _userFBID = [KeyChainWrapper getSelfFBID];
    [_notifications removeAllObjects];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"KeywordUpdate"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"fbID == %@", _userFBID]];

    [self fetch:request andAddToNotifications:_notifications];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Quiz"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(option0 == %@ OR option1 == %@) AND author != %@", _userFBID, _userFBID, _userFBID]];
    
    [self fetch:request andAddToNotifications:_notifications];

    request = [[NSFetchRequest alloc] initWithEntityName:@"CommentNotification"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"commenterFBID != %@", _userFBID]];
    
    [self fetch:request andAddToNotifications:_notifications];
    MBDebug(@"Fetched Notfication coming: %@", _notifications);
    [_notifications sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]]];
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
    id post = [_notifications objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SinglePostViewControllerSegue" sender:post];

//    User *personSelected = [_notifications objectAtIndex:indexPath.row];
//    if(_delegate && [_delegate respondsToSelector:@selector(selectedPerson:)]){
//        [_delegate selectedPerson:personSelected];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
    if (!cell){
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notificationCellIdentifier];
    }
    id post = [_notifications objectAtIndex:indexPath.row];
    [cell setCellPost:post];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @" "
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    if([[segue destinationViewController] isKindOfClass:[SinglePostViewController class]]){
        SinglePostViewController *vc = (SinglePostViewController *)[segue destinationViewController];
        [vc setSinglePost:sender];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
