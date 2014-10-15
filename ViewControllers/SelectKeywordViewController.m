//
//  SelectkeywordViewController.m
//  Marble
//
//  Created by Iru on 10/8/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "SelectKeywordViewController.h"
#import "SelectKeywordViewCell.h"


@interface SelectKeywordViewController()
@property (strong, nonatomic) NSMutableArray *keywordArray;

@end


@implementation SelectKeywordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _keywordArray = [[NSMutableArray alloc] init];
}

-(void) displaySearchResult:(NSArray *)arrayOfKeywords{
    _keywordArray = [arrayOfKeywords copy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_keywordArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_delegate && [_delegate respondsToSelector:@selector(selectedKeyword:)]){
        [_delegate selectedKeyword:[_keywordArray objectAtIndex:indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectKeywordViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:selectKeywordViewCellIdentifier];
    if (!cell){
        cell = [[SelectKeywordViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectKeywordViewCellIdentifier];
    }
    [cell setKeyword:[_keywordArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



@end
