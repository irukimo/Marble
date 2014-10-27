//
//  KeywordView.h
//  Marble
//
//  Created by Iru on 10/26/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "MDCSwipeToChooseView.h"

@interface KeywordView : MDCSwipeToChooseView
@property (strong, nonatomic) NSString *keyword;
- (instancetype)initWithFrame:(CGRect)frame
                      keyword:(NSString *)keyword
                      options:(MDCSwipeToChooseViewOptions *)options;
@end
