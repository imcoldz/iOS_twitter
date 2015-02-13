//
//  TweetCell.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/11/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (nonatomic, assign) BOOL retweetHighlight;
@property (nonatomic, assign) BOOL favoriteHighlight;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
    
    UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyTapped)];
    replyTap.numberOfTapsRequired = 1;
    replyTap.numberOfTouchesRequired = 1;
    [self.replyImageView addGestureRecognizer:replyTap];
    [self.replyImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetTapped)];
    retweetTap.numberOfTapsRequired = 1;
    retweetTap.numberOfTouchesRequired = 1;
    [self.retweetImageView addGestureRecognizer:retweetTap];
    [self.retweetImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteTapped)];
    favoriteTap.numberOfTapsRequired = 1;
    favoriteTap.numberOfTouchesRequired = 1;
    [self.favoriteImageView addGestureRecognizer:favoriteTap];
    [self.favoriteImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;

    [self.profileImageView setImageWithURL: [NSURL URLWithString:self.tweet.author.profileImageUrl]];
    self.nameLabel.text = self.tweet.author.name;
    self.screenNameLabel.text = self.tweet.author.screenName;
    NSTimeInterval timeInterval = -1*[self.tweet.createdAt timeIntervalSinceNow];
    if(timeInterval < 60 ){
        self.timeLabel.text = [NSString stringWithFormat:@"%ldsec", (NSInteger)timeInterval];
    }else if(timeInterval < 3600){
        self.timeLabel.text = [NSString stringWithFormat:@"%ldmin", (NSInteger)(timeInterval/60)];
    }else if(timeInterval < 3600*24){
        self.timeLabel.text = [NSString stringWithFormat:@"%ldmin", (NSInteger)(timeInterval/3600)];
    }else{
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        self.timeLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:self.tweet.createdAt]];
    }
    
    self.tweetTextLabel.text = self.tweet.text;
    [self.replyImageView setImage:[UIImage imageNamed:@"reply_default"]];
    //[self.retweetImageView setImage:[UIImage imageNamed:@"retweet_default"]];
    //[self.favoriteImageView setImage:[UIImage imageNamed:@"favorite_default"]];
    [self updateButtonEffect];
}

- (void) replyTapped{
    NSLog(@"reply button tapped!");
}

- (void) updateButtonEffect{
    if(self.retweetHighlight){
        [self.retweetImageView setImage:[UIImage imageNamed:@"retweet_on"]];
    }else{
        [self.retweetImageView setImage:[UIImage imageNamed:@"retweet_default"]];
    }
    if(self.favoriteHighlight){
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite_on"]];
    }else{
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite_default"]];
    }
}

- (void) retweetTapped{
    NSLog(@"retweet button tapped!");
    self.retweetHighlight = !self.retweetHighlight;
    [self updateButtonEffect];
    
}

- (void) favoriteTapped{
    NSLog(@"favorite button tapped!");
    self.favoriteHighlight = !self.favoriteHighlight;
    [self updateButtonEffect];
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
}
@end
