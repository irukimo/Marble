//
//  RestKitInitializer.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "RestKitInitializer.h"

#import "Quiz.h"

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
                                                @"autho_profile_URL":    @"authorProfileURL",
                                                @"keyword":            @"keyword",
                                                @"option0":            @"option0",
                                                @"option0_name":        @"option0Name",
                                                @"option0_profile_URL":  @"option0ProfileURL",
                                                @"option1":            @"option1",
                                                @"option1_name":        @"option1Name",
                                                @"option1_profile_URL":  @"option1ProfileURL",
                                                @"time":               @"time"}];
    
    /* We map the entity by uuid. If it is an existing entity on the server side, we updateUUID after object mapping
     */
    quizMapping.identificationAttributes = @[@"uuid"];
    
    RKResponseDescriptor *quizGETResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:quizMapping
                                         method:RKRequestMethodGET
                                    pathPattern:@"quizzes"
                                        keyPath:@"Quiz"
                                    statusCodes:successCode];
    
    // add response descriptors to object manager
    [objectManager addResponseDescriptorsFromArray:@[quizGETResponseDescriptor]];

    /* Set up request descriptor
     *
     */
    
    RKObjectMapping *quizSerializationMapping = [RKObjectMapping requestMapping];
    [quizSerializationMapping addAttributeMappingsFromDictionary:@{@"author":     @"author",
                                                             @"keyword":     @"keyword",
                                                             @"option0":     @"option0",
                                                             @"option1":     @"option1",
                                                             @"answer":      @"answer",
                                                             @"uuid":        @"uuid"}];
    
    RKRequestDescriptor *quizPOSTRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:quizSerializationMapping
                                          objectClass:[Quiz class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodPOST];

    [objectManager addRequestDescriptorsFromArray:@[quizPOSTRequestDescriptor]];
    
    
    
    /* Set up routing
     *
     */
    //First off, class routes
    RKRoute *quizGETRoute = [RKRoute routeWithClass:[Quiz class] pathPattern:@"quizzes" method:RKRequestMethodGET];

    RKRoute *quizPOSTRoute = [RKRoute routeWithClass:[Quiz class] pathPattern:@"quizzes" method:RKRequestMethodPOST];
    
    //Thirdly, named routes
    RKRoute *sendDeviceTokenRoute = [RKRoute routeWithName:@"set_device_token" pathPattern:@"set_device_token" method:RKRequestMethodPOST];

    [objectManager.router.routeSet addRoutes:@[// class routes
                                               quizGETRoute, quizPOSTRoute,
                                               // named routes
                                               sendDeviceTokenRoute]];


}


@end
