//
//  OneTweetViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/12/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "OneTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface OneTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (nonatomic, assign) BOOL retweetHighlight;
@property (nonatomic, assign) BOOL favoriteHighlight;
@end

@implementation OneTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self){
        self.retweetHighlight = NO;
        self.favoriteHighlight = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"Tweet";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target: self action:@selector(onHomeButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target: self action:@selector(onReplyButton)];
    
    [self updateContent];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateContent{
    [self.profileImageView setImageWithURL: [NSURL URLWithString:self.tweet.author.profileImageUrl]];
    self.nameLabel.text = self.tweet.author.name;
    NSLog(@"in OneTweetViewController - user name is %@", self.nameLabel.text);
    
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
    [self updateButtonEffect];
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
}

- (void) onHomeButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onReplyButton{
    ComposeViewController * vc = [[ComposeViewController alloc] init];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void) replyTapped{
    NSLog(@"reply button tapped!");
    ComposeViewController * vc = [[ComposeViewController alloc] init];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
