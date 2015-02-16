//
//  TweetCell.h
//  ttapp
//
//  Created by Xiangyu Zhang on 2/11/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)didTapProfileImage:(TweetCell *)cell;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@property (nonatomic, strong) Tweet * tweet;

@end
