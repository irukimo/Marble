//
//  SelectPeopleViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "SelectPeopleViewController.h"
#import "SelectPeopleViewCell.h"
#import "User.h"

@interface SelectPeopleViewController ()
@end

@implementation SelectPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _peopleArray = [[NSMutableArray alloc] init];
//    NSManagedObjectContext *context = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    
//    _peopleArray = [NSArray arrayWithObjects:@"Peanut",@"Wen Shaw",  nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setPeopleArray:(NSArray *)array{
    NSLog(@"setpeoplearraycalled");
    _peopleArray = [array copy];
    [self.tableView reloadData];
}


-(void) displaySearchResult:(NSArray *)arrayOfUsers{
    _peopleArray = [[NSMutableArray alloc] init];
    for(id user in arrayOfUsers){
        if([user isKindOfClass:[User class]]){
            User *thisUser = (User *)user;
            [_peopleArray addObject:thisUser];
            NSLog(@"Time to display %@, %@", thisUser.name, thisUser.fbID);
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_peopleArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *personSelected = [_peopleArray objectAtIndex:indexPath.row];
    if(_delegate && [_delegate respondsToSelector:@selector(selectedPerson:)]){
        [_delegate selectedPerson:personSelected];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectPeopleViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:selectPeopleViewCellIdentifier];
    if (!cell){
        cell = [[SelectPeopleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectPeopleViewCellIdentifier];
    }
    
    User *user = [_peopleArray objectAtIndex:indexPath.row];
    [cell setPersonName:user.name];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
