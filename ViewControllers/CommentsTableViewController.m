//
//  CommentsTableViewController.m
//  Marble
//
//  Created by Iru on 10/15/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "CommentsTableViewController.h"

@interface CommentsTableViewController()
@property (strong, nonatomic) NSMutableArray *commentsArray;

@end

@implementation CommentsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _commentsArray = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillRecede:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)setCommentArray:(NSArray *)commentArray{
    _commentsArray = [commentArray copy];
    [self.tableView reloadData];
    [self scrollTableViewToBottom];
}

- (void)scrollTableViewToBottom
{
    CGFloat yOffset = 0;
    
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

- (void)keyboardWillShow
{
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,/*KEYBOARD_HEIGHT*/254,0)];
    // auto scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + KEYBOARD_HEIGHT);
    [self.tableView setContentOffset:bottomOffset animated:YES];
    
}
- (void)keyboardWillRecede:(NSNotification*)notification
{
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_commentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:commentsTableViewCellIdentifier];
    if (!cell){
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentsTableViewCellIdentifier];
    }
    NSDictionary *comment = [_commentsArray objectAtIndex:indexPath.row];
    [cell setName:[comment valueForKey:@"name"] andID:[comment valueForKey:@"fb_id"] andComment:[comment valueForKey:@"comment"] andTime:[comment valueForKey:@"time"]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



#pragma mark - CommentsTableViewCell Delegate Method
-(void) gotoProfile:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary *comment = [_commentsArray objectAtIndex:indexPath.row];
    if(_delegate && [_delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [_delegate gotoProfileWithName:[comment valueForKey:@"name"] andID:[comment valueForKey:@"fb_id"]];
    }
}

@end
