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

#define PRODUCTION_SERVER @"192.168.2.103"
//#define PRODUCTION_SERVER @"localhost"

#define ASYNC(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ __VA_ARGS__ })

#define BASE_URL URLMake(PRODUCTION_SERVER)

#endif
