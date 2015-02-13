//
//  Tweet.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/9/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        NSString * createdAtString = dictionary[@"created_at"];
        //self.createdAt = dictionary[@""]
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *) dictionaries{

    NSMutableArray * tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries){
        [tweets addObject: [[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
