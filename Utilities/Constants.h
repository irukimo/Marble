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

#define PRODUCTION_SERVER @"192.168.0.103"
//#define PRODUCTION_SERVER @"localhost"

#define ASYNC(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ __VA_ARGS__ })

#define BASE_URL URLMake(PRODUCTION_SERVER)


#define quizTableViewCellIdentifier    @"quizTableViewCellIdentifier"
#define statusTableViewCellIdentifier  @"statusTableViewCellIdentifier"
#define keywordUpdateTableViewCellIdentifier @"keywordUpdateTableViewCellIdentifier"
#define keywordListTableViewCellIdentifier @"keywordListTableViewCellIdentifier"

#define QuizTableViewCellHeight 160
#define StatusUpdateTableViewCellHeight 50
#define KeywordUpdateTableViewCellHeight 50
#define CommentIncrementHeight 20

#define TABBAR_HEIGHT 49

#define HOME_POSTS_TYPE @"home_posts_type"
#define PROFILE_POSTS_TYPE @"profile_posts_type"
#define KEYWORD_POSTS_TYPE @"keyword_posts_type"


#endif
