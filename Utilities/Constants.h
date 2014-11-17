//
//  Constants.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#ifndef Marble_Constants_h
#define Marble_Constants_h

#define MBDebug NSLog
#define MBError NSLog
#define URLMake(IP) (@"http://" IP @":4567/")

#define PRODUCTION_SERVER @"192.168.2.240"
//#define PRODUCTION_SERVER @"localhost"

#define ASYNC(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ __VA_ARGS__ })
#define MAINQ(...) dispatch_async(dispatch_get_main_queue(), ^{ __VA_ARGS__ })

#define BASE_URL URLMake(PRODUCTION_SERVER)

#define NUM_QUIZZES_PER_PAGE 20
#define NUM_UPDATES_PER_PAGE 20

#define MARBLE_IMAGE_NAME @"marble.png"
#define HEART_IMAGE_NAME @"heart.png"
#define EMPTY_HEART_IMAGE_NAME @"heart-empty.png"
#define COMMENT_ICON_IMAGE_NAME @"comment.png"

#define MBSignOutNotification @"MSSignOutNotification"

#define notificationCellIdentifier @"notificationCellIdentifier"

#define quizTableViewCellIdentifier    @"quizTableViewCellIdentifier"
#define statusTableViewCellIdentifier  @"statusTableViewCellIdentifier"
#define keywordUpdateTableViewCellIdentifier @"keywordUpdateTableViewCellIdentifier"

#define singlePostQuizTableViewCellIdentifier    @"singlePostQuizTableViewCellIdentifier"
#define singlePostStatusTableViewCellIdentifier  @"singlePostStatusTableViewCellIdentifier"
#define singlePostKeywordUpdateTableViewCellIdentifier @"singlePostKeywordUpdateTableViewCellIdentifier"


#define keywordListTableViewCellIdentifier @"keywordListTableViewCellIdentifier"

#define selectKeywordViewCellIdentifier @"selectKeywordViewCellIdentifier"
#define selectPeopleViewCellIdentifier @"selectPeopleViewCellIdentifier"
#define commentsTableViewCellIdentifier @"commentsTableViewCellIdentifier"

#define exploreCollectionViewCellIdentifier @"exploreCollectionViewCellIdentifier"

#define QuizTableViewCellHeight 305
#define QuizTableViewCellDisplayHeight 315
#define QuizImageWidthAndCellHeightDifference 157
#define QuizImageWidthAndCellDisplayHeightDifference 167
#define StatusUpdateTableViewCellHeight 110
#define KeywordUpdateTableViewCellHeight 110
#define StatusUpdateTableViewCellDisplayHeight 115
#define KeywordUpdateTableViewCellDisplayHeight 115
#define FirstCommentIncrementHeight 25
#define CommentIncrementHeight 18

#define KEYWORD_LIST_CELL_EXPAND_HEIGHT 155
#define KEYWORD_LIST_CELL_UNEXPAND_HEIGHT 70

#define TABBAR_HEIGHT 49
#define NAVBAR_HEIGHT 64
#define KEYBOARD_HEIGHT 260
#define LEFT_ALIGNMENT 25
#define NAME_LEFT_ALIGNMENT 75
#define NAME_TOP_ALIGNMENT 16

#define CELL_UNIVERSAL_PADDING 12




typedef NS_ENUM(NSUInteger, NotificationType) {
    MBCommentNotification,
    MBQuiz,
    MBKeyword
};

typedef NS_ENUM(NSUInteger, PostCellType) {
    MBQuizCellType,
    MBStatusUpdateCellType,
    MBKeywordUpdateCellType
};


#endif
