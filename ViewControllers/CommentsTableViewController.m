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
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) UIViewAnimationCurve keyboardCurve;


@end

@implementation CommentsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _commentsArray = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
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

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyboardCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,/*KEYBOARD_HEIGHT*/_keyboardSize.height,0)];
    // auto scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + _keyboardSize.height);
    [self.tableView setContentOffset:bottomOffset animated:YES];
    
}
- (void)keyboardWillRecede:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyboardCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
//    [UIView setAnimationCurve:_keyboardCurve];
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    [UIView commitAnimations];
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
    NSDictionary *commentDic = [_commentsArray objectAtIndex:indexPath.row];
    NSString *comment = [commentDic valueForKey:@"comment"];
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getWhiteCommentFontDictionary]];
    if (commentString.size.width > ([KeyChainWrapper getScreenWidth] - (LEFT_ALIGNMENT + 50) - 20 -10))
    {
        return 70;
    }

    return 50;
}



#pragma mark - CommentsTableViewCell Delegate Method
-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid{
    if(_delegate && [_delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [_delegate gotoProfileWithName:name andID:fbid];
    }
}

@end
