//
//  TwitterClient.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/9/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"dEqgG4ep3ol8Z0rfa4fxTRX1X";
NSString * const kTwitterConsumerSecret = @"EoQCUh8rgHzYcfMvnyDpoIGV0K7t0JbUJGpanMwMbOuEgwwESZ";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";


@interface TwitterClient()

@property (nonatomic, strong) void(^loginCompletion)(User *user, NSError * error);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance{
    static TwitterClient * instance = nil;

    //make initialization thread-safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance  = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion{

    self.loginCompletion = completion;
    
    //remove old token to avoid 404 error
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token!");
        NSURL * authURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the request token!");
        self.loginCompletion(nil, error);
    }];
    
}

- (void) openURL:(NSURL *)url{
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"current user: %@", responseObject);
            User * user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to get current user");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {   
        NSLog(@"failed to get the access token");
        self.loginCompletion(nil, error);
    }];

    
}

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray * tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        //NSLog(@"home_timeline tweets: %@", responseObject);
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    } ];
}

- (void) updateWithParams:(NSDictionary *)params completion:(void(^)(NSObject *responseObject, NSError *error))completion{
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        //NSLog(@"home_timeline tweets: %@", responseObject);
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    } ];
}

- (void) loadUserTweetsWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        //NSLog(@"user_timeline tweets: %@", responseObject);
        completion(tweets, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    } ];
}

@end
