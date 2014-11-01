//
//  KeywordListViewController.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordListViewController.h"
#import "KeywordListTableViewCell.h"
#import "KeywordProfileViewController.h"

static const int EXPAND_HEIGHT = 150;
static const int UNEXPAND_HEIGHT  = 60;

@interface KeywordListViewController ()

@property (strong, nonatomic) NSMutableArray *keywordList;
@property (strong, nonatomic) NSIndexPath *ongoingPath;

@end

@implementation KeywordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSManagedObjectContext *context = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.view setBackgroundColor:[UIColor marbleLightGray]];
    [self.tableView setBackgroundColor:[UIColor marbleLightGray]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    _ongoingPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    for (NSArray *obj in _keywordList) {
        MBDebug(@"KEYWORDLIST: keyword: %@", [obj objectAtIndex:1]);
        NSDictionary *dict = [obj objectAtIndex:2];
        /* each keyword:
          * [
          *   times played,
          *   keyword,
          *   { 
          *     after: {fb_id: xxxx, name: xxxx, rank: (number)},
          *     self: (number),
          *     before: {fb_id: xxxx, name: xxxx, rank: (number)}
          *   }
          * ]
          * NOTE: after/before might correspond to nil value.
          */
        for (NSString *key in dict) {
            if ([key isEqualToString:@"self"]) {
                MBDebug(@"self ranking: %@", [dict objectForKey:key]);
            } else {
                MBDebug(@"other ranking: %@, %@", key, [dict objectForKey:key]);
            }
        }
    }
    
}

#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_ongoingPath isEqual:indexPath]){
        _ongoingPath = nil;
    } else{
        _ongoingPath = indexPath;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_keywordList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KeywordListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:keywordListTableViewCellIdentifier];
    if (!cell){
        cell = [[KeywordListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keywordListTableViewCellIdentifier];
    }
    cell.subject = _subject;
    [cell setKeyword:[_keywordList objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

-(void) gotoKeywordProfileWithKeyword:(NSString *)keyword{
    [self performSegueWithIdentifier:@"KeywordProfileViewControllerSegue" sender:keyword];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath isEqual:_ongoingPath]){
        return EXPAND_HEIGHT;
    }
    return UNEXPAND_HEIGHT;
}

-(void) setKeywords:(id)keywords{
    if(keywords){
        if([keywords isKindOfClass:[NSString class]]){
            NSString *keyword = (NSString *)keywords;
            _keywordList = [[NSMutableArray alloc] initWithObjects:keyword, nil];
        } else if([keywords isKindOfClass:[NSArray class]]){
            NSArray *keywordArray = (NSArray *)keywords;
            _keywordList = [[NSMutableArray alloc] initWithArray:keywordArray];
        }
    }
    [self.tableView reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @" "
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
//    UINavigationBar *myNavBar =[self.navigationController navigationBar];
//    [[myNavBar topItem] setTitle:sender];

    
    if([segue.destinationViewController isKindOfClass:[KeywordProfileViewController class]]){
        KeywordProfileViewController *vc = segue.destinationViewController;
        [vc setKeyword:sender];
    }
}


@end
