//
//  MentionsViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/16/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "MentionsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "AFNetworking.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"


@interface MentionsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (nonatomic, strong)NSArray * myTweets;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    //self.navigationController.navigationBar.translucent = YES;
    self.title =@"Mentions";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target: self action:@selector(onBackButton)];
    
    [self updateUserContent];
    // Do any additional setup after loading the view from its nib.
    
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    [self.tweetsTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    [self loadUserMentions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(User *)user{
    _user = user;
}

- (void) updateUserContent{
    [self.profileImageView setImageWithURL: [NSURL URLWithString:self.user.profileImageUrl]];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
}

- (void) onBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadUserMentions{
    NSLog(@"loading mentions of %@", self.user.screenName);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //set up count
    NSString *tweetsCount = @"5";
    [params setObject:tweetsCount forKey:@"count"];
    
    [[TwitterClient sharedInstance] loadUserMentionsWithParams:params completion:^(NSArray * tweets, NSError *error) {
        if(error==nil){
            NSLog(@"MentionsViewController: tweets loaded without error.");
            //NSLog(@"tweets are: %@", responseObject);
            self.myTweets = [NSArray arrayWithArray:tweets];
            NSLog(@"count of mentions is: %ld", self.myTweets.count);
            if(self.myTweets.count == 0){
                [UIView animateWithDuration:0.6 animations:^{
                    CGRect frame = self.tweetsTableView.frame;
                    frame.origin.y = frame.origin.y+40;
                    self.tweetsTableView.frame = frame;
                }];
            }else{
                [self.tweetsTableView reloadData];
            }
        }else{
            NSLog(@"MentionsViewController: mentions loading encounters error: %@", [error localizedDescription]);
        }
    }];
}

#pragma mark - tableview delegate methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myTweets.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell * cell = [self.tweetsTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet * t = self.myTweets[indexPath.row];
    cell.tweet = t;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
@end
