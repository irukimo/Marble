//
//  Post+MBPost.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "Post.h"

@interface Post (MBPost)

- (void) initParentAttributes;
+ (void)setIndicesAsRefreshing:(NSArray *)posts;
+ (void)setIndicesAsLoadingMore:(NSArray *)posts;

@end
