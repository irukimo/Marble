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
                                                @"compare_num":        @"compareNum"}];
    
    /* We map the entity by uuid. If it is an existing entity on the server side, we updateUUID after object mapping
     */
    quizMapping.identificationAttributes = @[@"uuid"];
    
    RKResponseDescriptor *quizGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:quizMapping
                                         method:RKRequestMethodGET
                                    pathPattern:@"quizzes"
                                        keyPath:@"Quiz"
                                    statusCodes:successCode];
    
    
    
    // options mapping
    RKEntityMapping *optionsMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [optionsMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                         @"fb_id": @"fbID"}];
    
    optionsMapping.identificationAttributes = @[@"fbID"];
    
    RKResponseDescriptor *optionsGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:optionsMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"options"
                                                keyPath:nil
                                            statusCodes:successCode];
    
    
    // comments mapping
    RKEntityMapping *commentsMapping = [RKEntityMapping mappingForEntityForName:@"Quiz" inManagedObjectStore:managedObjectStore];
    [commentsMapping addAttributeMappingsFromDictionary:@{@"comments": @"comments",
                                                          @"uuid": @"uuid"}];
    commentsMapping.identificationAttributes = @[@"uuid"];
    RKResponseDescriptor *commentsGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:commentsMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"comments"
                                                keyPath:nil
                                            statusCodes:successCode];
    

    // status mapping
    RKEntityMapping *statusMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [statusMapping addAttributeMappingsFromDictionary:@{@"status": @"status",
                                                  @"fb_id": @"fbID"}];
    statusMapping.identificationAttributes = @[@"fbID"];
    RKResponseDescriptor *statusGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:statusMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"status"
                                                keyPath:nil
                                            statusCodes:successCode];

    
    // status mapping
    RKEntityMapping *statusUpdateMapping = [RKEntityMapping mappingForEntityForName:@"StatusUpdate" inManagedObjectStore:managedObjectStore];
    [statusUpdateMapping addAttributeMappingsFromDictionary:@{@"status":    @"status",
                                                        @"fb_id":     @"fbID",
                                                        @"created_at": @"time",
                                                        @"name":      @"name",
                                                        @"uuid":      @"uuid"}];
    statusUpdateMapping.identificationAttributes = @[@"uuid"];
    RKResponseDescriptor *statusUpdateGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:statusUpdateMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"updates"
                                                keyPath:@"Status"
                                            statusCodes:successCode];
    
    // add response descriptors to object manager
    [objectManager addResponseDescriptorsFromArray:@[quizGETResponseDescriptor,
                                                     optionsGETResponseDescriptor,
                                                     commentsGETResponseDescriptor,
                                                     statusGETResponseDescriptor,
                                                     statusUpdateGETResponseDescriptor]];

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

    
    RKObjectMapping *statusSerializationMapping = [RKObjectMapping requestMapping];
    [statusSerializationMapping addAttributeMappingsFromDictionary:@{@"status": @"status"}];
    
    RKRequestDescriptor *statusPOSTRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:statusSerializationMapping
                                          objectClass:[User class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodPOST];

    [objectManager addRequestDescriptorsFromArray:@[quizPOSTRequestDescriptor
                                                    ,statusPOSTRequestDescriptor
                                                    ]];
    
    
    
    
    /* Set up routing
     *
     */
    //First off, class routes
    RKRoute *quizGETRoute = [RKRoute routeWithClass:[Quiz class] pathPattern:@"quizzes" method:RKRequestMethodGET];

    RKRoute *quizPOSTRoute = [RKRoute routeWithClass:[Quiz class] pathPattern:@"quizzes" method:RKRequestMethodPOST];
    
    RKRoute *statusPOSTRoute = [RKRoute routeWithClass:[User class] pathPattern:@"status" method:RKRequestMethodPOST];
    
    RKRoute *postGETRoute = [RKRoute routeWithClass:[Post class] pathPattern:@"updates" method:RKRequestMethodGET];
    
    //Thirdly, named routes
    RKRoute *sendDeviceTokenRoute = [RKRoute routeWithName:@"set_device_token" pathPattern:@"set_device_token" method:RKRequestMethodPOST];
    
    RKRoute *sendCommentRoute = [RKRoute routeWithName:@"send_comment" pathPattern:@"comments" method:RKRequestMethodPOST];
    
    RKRoute *getCommentsRoute = [RKRoute routeWithName:@"get_comments" pathPattern:@"comments" method:RKRequestMethodGET];
    
    RKRoute *sendGuessRoute = [RKRoute routeWithName:@"send_guess" pathPattern:@"guesses" method:RKRequestMethodPOST];
    
    RKRoute *sendStatusRoute = [RKRoute routeWithName:@"send_status" pathPattern:@"status" method:RKRequestMethodPOST];
    
    [objectManager.router.routeSet addRoutes:@[// class routes
                                               quizGETRoute, quizPOSTRoute, statusPOSTRoute, postGETRoute,
                                               // named routes
                                               sendDeviceTokenRoute, sendCommentRoute, getCommentsRoute, sendGuessRoute, sendStatusRoute]];


}


@end
