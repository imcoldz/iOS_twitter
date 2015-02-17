//
//  TwitterClient.h
//  ttapp
//
//  Created by Xiangyu Zhang on 2/9/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void) openURL:(NSURL *)url;

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray * tweets, NSError *error))completion;

- (void) updateWithParams:(NSDictionary *)params completion:(void(^)(NSObject * responseObject, NSError *error))completion;

- (void) loadUserTweetsWithParams:(NSDictionary *)params completion:(void(^)(NSArray * tweets, NSError *error))completion;

- (void) loadUserMentionsWithParams:(NSDictionary *)params completion:(void(^)(NSArray * tweets, NSError *error))completion;

@end
