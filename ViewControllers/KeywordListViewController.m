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

@interface KeywordListViewController ()

@property (strong, nonatomic) NSMutableArray *keywordList;

@end

@implementation KeywordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSManagedObjectContext *context = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    
    //    _peopleArray = [NSArray arrayWithObjects:@"Peanut",@"Wen Shaw",  nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

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
    
    [cell setKeyword:[_keywordList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"KeywordProfileViewControllerSegue" sender:[_keywordList objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
