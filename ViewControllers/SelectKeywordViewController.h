//
//  SelectkeywordViewController.h
//  Marble
//
//  Created by Iru on 10/8/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectKeywordViewControllerDelegate;

@interface SelectKeywordViewController : UITableViewController
@property (nonatomic, weak) id<SelectKeywordViewControllerDelegate> delegate;
-(void) displaySearchResult:(NSArray *)arrayOfKeywords;
@end


@protocol SelectKeywordViewControllerDelegate <NSObject>

- (void)selectedKeyword:(NSString *)keyword;


@end