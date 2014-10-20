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

//#define PRODUCTION_SERVER @"192.168.2.241"
#define PRODUCTION_SERVER @"localhost"

#define ASYNC(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ __VA_ARGS__ })

#define BASE_URL URLMake(PRODUCTION_SERVER)

#define notificationCellIdentifier @"notificationCellIdentifier"

#define quizTableViewCellIdentifier    @"quizTableViewCellIdentifier"
#define statusTableViewCellIdentifier  @"statusTableViewCellIdentifier"
#define keywordUpdateTableViewCellIdentifier @"keywordUpdateTableViewCellIdentifier"
#define keywordListTableViewCellIdentifier @"keywordListTableViewCellIdentifier"

#define selectKeywordViewCellIdentifier @"selectKeywordViewCellIdentifier"
#define selectPeopleViewCellIdentifier @"selectPeopleViewCellIdentifier"
#define commentsTableViewCellIdentifier @"commentsTableViewCellIdentifier"

#define exploreCollectionViewCellIdentifier @"exploreCollectionViewCellIdentifier"

#define QuizTableViewCellHeight 230
#define StatusUpdateTableViewCellHeight 90
#define KeywordUpdateTableViewCellHeight 90
#define CommentIncrementHeight 20

#define TABBAR_HEIGHT 49
#define NAVBAR_HEIGHT 64
#define KEYBOARD_HEIGHT 260
#define LEFT_ALIGNMENT 25

#define HOME_POSTS_TYPE @"home_posts_type"
#define PROFILE_POSTS_TYPE @"profile_posts_type"
#define KEYWORD_POSTS_TYPE @"keyword_posts_type"

#define QUIZ_CELL_TYPE @"quiz_cell_type"
#define STATUS_UPDATE_CELL_TYPE @"status_update_cell_type"
#define KEYWORD_UPDATE_CELL_TYPE @"keyword_update_cell_type"

#define COMMENT_DEFAULT_TEXT @"[write a comment]"


typedef NS_ENUM(NSUInteger, NotificationType) {
    MBCommentNotification,
    MBQuiz,
    MBKeyword
};

#endif
