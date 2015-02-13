//
//  User.h
//  ttapp
//
//  Created by Xiangyu Zhang on 2/9/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotifiction;
extern NSString * const UserDidLogoutNotifiction;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;


- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (User *) currentUser;
+ (void) setCurrentUser: (User *)user;
+ (void) logout;

@end
