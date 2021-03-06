//
//  User.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/9/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotifiction = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotifiction = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic, strong) NSDictionary * dictionary;

@end


@implementation User

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
        self.bannerImageUrl = dictionary[@"profile_banner_url"];
        self.tweetNumber = [NSNumber numberWithInt:0];
        self.followingNumber = [NSNumber numberWithInt:0];
        self.followerNumber = [NSNumber numberWithInt:0];
        if (dictionary[@"statuses_count"]){
            //NSLog(@"following from api response: %@", dictionary[@"following"]);
            self.tweetNumber = dictionary[@"statuses_count"];
        }
        if (dictionary[@"following"]){
            //NSLog(@"following from api response: %@", dictionary[@"following"]);
            self.followingNumber = dictionary[@"following"];
        }
        if (dictionary[@"followers_count"]){
            //NSLog(@"followers_count from api response: %@", dictionary[@"followers_count"]);
            self.followerNumber = dictionary[@"followers_count"];
        }
    }
    return self;
}

static User* _currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *) currentUser{
    if( _currentUser == nil){
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey: kCurrentUserKey];
        if (data!=nil){
            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void) setCurrentUser:(User *)currentUser{

    _currentUser = currentUser;
    
    if( _currentUser!=nil){
        NSData * data =  [ NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void) logout{
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotifiction object:nil];
}
@end
