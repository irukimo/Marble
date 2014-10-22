//
//  RestKitInitializer.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "RestKitInitializer.h"

#import "User.h"
#import "Quiz.h"
#import "Post.h"
#import "StatusUpdate.h"

@implementation RestKitInitializer

+ (void) setupWithObjectManager:(RKObjectManager *)objectManager inManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
//    // you can do things like post.id too
//    // set up mapping and response descriptor
//    
    NSIndexSet *successCode = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
//
    // entity mapping
    RKEntityMapping *quizMapping = [RKEntityMapping mappingForEntityForName:@"Quiz" inManagedObjectStore:managedObjectStore];
    
    // 'fb' in fbUserID is not capitalized is because Core Data attributes have to start with small cases
    //
    [quizMapping addAttributeMappingsFromDictionary:@{@"uuid":              @"uuid",
                                                @"author":             @"author",
                                                @"author_name"   :      @"authorName",
                                                @"keyword":            @"keyword",
                                                @"option0":            @"option0",
                                                @"option0_name":        @"option0Name",
                                                @"option1":            @"option1",
                                                @"option1_name":        @"option1Name",
                                                @"answer":             @"answer",
                                                @"created_at":               @"time",
                                                @"compare_num":        @"compareNum",
                                                      @"popularity":  @"popularity",
                                                      @"answered_before": @"guessed"}];
    
    /* We map the entity by uuid. If it is an existing entity on the server side, we updateUUID after object mapping
     */
    quizMapping.identificationAttributes = @[@"uuid"];
    
    RKResponseDescriptor *quizPOSTResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:quizMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"quizzes"
                                                keyPath:nil
                                            statusCodes:successCode];
    
    RKResponseDescriptor *quizGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:quizMapping
                                         method:RKRequestMethodGET
                                    pathPattern:@"quizzes"
                                        keyPath:@"Quiz"
                                    statusCodes:successCode];
    
    RKResponseDescriptor *quizNotifGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:quizMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"notifications"
                                                keyPath:@"quiz"
                                            statusCodes:successCode];
    
    // options mapping
    RKEntityMapping *optionsMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [optionsMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                         @"fb_id": @"fbID",
                                                         @"first_keyword": @"keywords"}];
    
    optionsMapping.identificationAttributes = @[@"fbID"];
    
    RKResponseDescriptor *optionsGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:optionsMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"options"
                                                keyPath:nil
                                            statusCodes:successCode];
    
    
    // comments mapping
    RKEntityMapping *commentsMapping = [RKEntityMapping mappingForEntityForName:@"Post" inManagedObjectStore:managedObjectStore];
    [commentsMapping addAttributeMappingsFromDictionary:@{@"comments": @"comments",
                                                          @"uuid": @"uuid"}];
    commentsMapping.identificationAttributes = @[@"uuid"];
    RKResponseDescriptor *commentsGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:commentsMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"comments"
                                                keyPath:nil
                                            statusCodes:successCode];
    

    // user mapping
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [userMapping addAttributeMappingsFromDictionary:@{@"latest_status": @"status",
                                                    @"fb_id":        @"fbID",
                                                    @"all_profile_keywords": @"keywords",
                                                    @"name":         @"name"}];
    userMapping.identificationAttributes = @[@"fbID"];
    RKResponseDescriptor *userGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"user"
                                                keyPath:nil
                                            statusCodes:successCode];

    
    // status update mapping
    RKEntityMapping *statusUpdateMapping = [RKEntityMapping mappingForEntityForName:@"StatusUpdate" inManagedObjectStore:managedObjectStore];
    [statusUpdateMapping addAttributeMappingsFromDictionary:@{@"status":    @"status",
                                                        @"fb_id":     @"fbID",
                                                        @"created_at": @"time",
                                                        @"name":      @"name",
                                                        @"popularity":  @"popularity",
                                                        @"uuid":      @"uuid"}];
    statusUpdateMapping.identificationAttributes = @[@"uuid"];
    RKResponseDescriptor *statusUpdateGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:statusUpdateMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"updates"
                                                keyPath:@"Status_Update"
                                            statusCodes:successCode];
    // keyword update mapping
    RKEntityMapping *keywordUpdateMapping = [RKEntityMapping mappingForEntityForName:@"KeywordUpdate"
                                                                inManagedObjectStore:managedObjectStore];
    [keywordUpdateMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                             @"fb_id": @"fbID",
                                                             @"created_at": @"time",
                                                             @"uuid": @"uuid",
                                                             @"popularity":  @"popularity",
                                                             @"keywords": @"keywords"}];
    keywordUpdateMapping.identificationAttributes = @[@"uuid"];
    RKResponseDescriptor *keywordUpdateGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:keywordUpdateMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"updates"
                                                keyPath:@"Keyword_Update"
                                            statusCodes:successCode];
    
    RKResponseDescriptor *keywordUpdateNotifGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:keywordUpdateMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"notifications"
                                                keyPath:@"keyword_update"
                                            statusCodes:successCode];
    
    // comment notification mapping
    RKEntityMapping *commentNotificationMapping = [RKEntityMapping mappingForEntityForName:@"CommentNotification"
                                                                      inManagedObjectStore:managedObjectStore];
    
    [commentNotificationMapping addAttributeMappingsFromDictionary:@{@"time": @"time",
                                                                 @"fb_id": @"commenterFBID",
                                                                 @"name": @"commenterName",
                                                                 @"comment": @"comment",
                                                                 @"post_uuid": @"postUUID",
                                                                 @"type": @"type"
                                                                 }];
    RKResponseDescriptor *commentNotifGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:commentNotificationMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"notifications"
                                                keyPath:@"comment"
                                            statusCodes:successCode];
    
    // add response descriptors to object manager
    [objectManager addResponseDescriptorsFromArray:@[quizGETResponseDescriptor,
                                                     optionsGETResponseDescriptor,
                                                     commentsGETResponseDescriptor,
                                                     userGETResponseDescriptor,
                                                     statusUpdateGETResponseDescriptor,
                                                     keywordUpdateGETResponseDescriptor,
                                                     quizNotifGETResponseDescriptor,
                                                     keywordUpdateNotifGETResponseDescriptor,
                                                     commentNotifGETResponseDescriptor,
                                                     quizPOSTResponseDescriptor]];

    /* Set up request descriptor
     *
     */
    
    RKObjectMapping *quizSerializationMapping = [RKObjectMapping requestMapping];
    [quizSerializationMapping addAttributeMappingsFromDictionary:@{@"author":     @"author",
                                                             @"authorName":     @"author_name",
                                                             @"keyword":     @"keyword",
                                                             @"option0":     @"option0",
                                                             @"option1":     @"option1",
                                                             @"option0Name":     @"option0_name",
                                                             @"option1Name":     @"option1_name",
                                                             @"answer":      @"answer",
                                                             @"uuid":        @"uuid"}];
    
    RKRequestDescriptor *quizPOSTRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:quizSerializationMapping
                                          objectClass:[Quiz class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodPOST];

    
//    RKObjectMapping *statusSerializationMapping = [RKObjectMapping requestMapping];
//    [statusSerializationMapping addAttributeMappingsFromDictionary:@{@"status": @"status"}];
//    
//    RKRequestDescriptor *statusPOSTRequestDescriptor =
//    [RKRequestDescriptor requestDescriptorWithMapping:statusSerializationMapping
//                                          objectClass:[User class]
//                                          rootKeyPath:nil
//                                               method:RKRequestMethodPOST];
//
    /*
      * Note that Request Descriptors are never called for GET requests
      */


    [objectManager addRequestDescriptorsFromArray:@[quizPOSTRequestDescriptor,
//                                                    statusPOSTRequestDescriptor,
                                                    ]];
    
    
    
    
    /* Set up routing
     *
     */
    //First off, class routes
    RKRoute *quizGETRoute = [RKRoute routeWithClass:[Quiz class] pathPattern:@"quizzes" method:RKRequestMethodGET];

    RKRoute *quizPOSTRoute = [RKRoute routeWithClass:[Quiz class] pathPattern:@"quizzes" method:RKRequestMethodPOST];
    
//    RKRoute *statusPOSTRoute = [RKRoute routeWithClass:[User class] pathPattern:@"status" method:RKRequestMethodPOST];
    
    RKRoute *userGETRoute = [RKRoute routeWithClass:[User class] pathPattern:@"user" method:RKRequestMethodGET];
    
    RKRoute *postGETRoute = [RKRoute routeWithClass:[Post class] pathPattern:@"updates" method:RKRequestMethodGET];
    
    //Thirdly, named routes
    RKRoute *sendDeviceTokenRoute = [RKRoute routeWithName:@"set_device_token" pathPattern:@"set_device_token" method:RKRequestMethodPOST];
    
    RKRoute *sendCommentRoute = [RKRoute routeWithName:@"send_comment" pathPattern:@"comments" method:RKRequestMethodPOST];
    
    RKRoute *getCommentsRoute = [RKRoute routeWithName:@"get_comments" pathPattern:@"comments" method:RKRequestMethodGET];
    
    RKRoute *sendGuessRoute = [RKRoute routeWithName:@"send_guess" pathPattern:@"guesses" method:RKRequestMethodPOST];
    
    RKRoute *sendStatusRoute = [RKRoute routeWithName:@"send_status" pathPattern:@"status" method:RKRequestMethodPOST];
    
    RKRoute *getNotificationsRoute = [RKRoute routeWithName:@"get_notifications" pathPattern:@"notifications" method:RKRequestMethodGET];
    
    RKRoute *setBadgeRoute = [RKRoute routeWithName:@"set_badge" pathPattern:@"set_badge_number" method:RKRequestMethodPOST];
    
    [objectManager.router.routeSet addRoutes:@[// class routes
                                               quizGETRoute, quizPOSTRoute, /*statusPOSTRoute,*/ postGETRoute, userGETRoute,
                                               // named routes
                                               sendDeviceTokenRoute, sendCommentRoute, getCommentsRoute,
                                               sendGuessRoute, sendStatusRoute, getNotificationsRoute, setBadgeRoute]];


}


@end
