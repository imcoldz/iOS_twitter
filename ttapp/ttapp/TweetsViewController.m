//
//  TweetsViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/11/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "OneTweetViewController.h"
#import "ProfileViewController.h"

@interface TweetsViewController ()<UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
{
    UIRefreshControl* refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *TweetsTableView;
@property (nonatomic, strong)NSArray * myTweets;
@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self){
        self.title = @"Home";
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.TweetsTableView reloadData];
}

- (void)reloadDatas{
    //grab data from twitterclient
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.myTweets = [NSArray arrayWithArray:tweets];
//        for (Tweet *t in self.myTweets){
//            NSLog(@"%@", t.text);
//        }
        [self.TweetsTableView reloadData];
        [refreshControl endRefreshing];
        [self.TweetsTableView reloadData];
        NSLog(@"refreshing done!");
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SignOut" style:UIBarButtonItemStylePlain target: self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target: self action:@selector(onComposeButton)];
    
    self.TweetsTableView.dataSource = self;
    self.TweetsTableView.delegate = self;
    
    [self.TweetsTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    [self.TweetsTableView addSubview:refreshControl];
    
    self.TweetsTableView.rowHeight = UITableViewAutomaticDimension;
    self.TweetsTableView.estimatedRowHeight = 50;
    
    [self reloadDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSignOutButton {
    [User logout];
}

- (void)onComposeButton {
    ComposeViewController * vc = [[ComposeViewController alloc] init];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - tableview delegate methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myTweets.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell * cell = [self.TweetsTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet * t = self.myTweets[indexPath.row];
    //NSLog(@"%@", t.text);
    //NSLog(@"%@", t.author.name);
    cell.tweet = t;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //to counter the select highlight effect:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OneTweetViewController * vc = [[OneTweetViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    Tweet * t = self.myTweets[indexPath.row];
    vc.tweet = t;
    //NSLog(@"after vc.tweet=t, stored tweet user name is %@", vc.tweet.author.name);
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)didTapProfileImage:(TweetCell *)cell{
    NSLog(@"Filter view controller got the Profile Image tap from cell.");
    ProfileViewController * vc = [[ProfileViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.user = cell.tweet.author;
    [self presentViewController:nvc animated:YES completion:nil];
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
