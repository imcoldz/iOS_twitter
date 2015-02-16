//
//  ProfileViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/15/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "AFNetworking.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"


@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumberLabel;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (nonatomic, strong)NSArray * myTweets;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    //self.navigationController.navigationBar.translucent = YES;
    self.title =@"Profile";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target: self action:@selector(onBackButton)];
    
    [self updateUserContent];
    // Do any additional setup after loading the view from its nib.
    
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    [self.tweetsTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    [self loadUserTweets];
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
    if(self.user.bannerImageUrl){
        
        NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString:self.user.bannerImageUrl]];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(connectionError == nil){
                UIImage *image = [[UIImage alloc]initWithData:data];
                
                UIGraphicsBeginImageContext(self.bannerView.frame.size);
                [image drawInRect:self.bannerView.bounds];
                UIImage *fitimg = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [self.bannerView setBackgroundColor:[UIColor colorWithPatternImage:fitimg]];
            }else{
                NSLog(@"banner iamge download failed: %@", [connectionError localizedDescription]);
            }
        }];
    }
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.tweetsNumberLabel.text = [self.user.tweetNumber stringValue];
    self.followingNumberLabel.text = [self.user.followingNumber stringValue];
    self.followerNumberLabel.text = [self.user.followerNumber stringValue];
}

- (void) onBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadUserTweets{
    NSLog(@"loading tweets of %@", self.user.screenName);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //set up screen_name
    NSString *screenNameString = self.user.screenName;
    [params setObject:screenNameString forKey:@"screen_name"];
    //set up count
    NSString *tweetsCount = @"5";
    [params setObject:tweetsCount forKey:@"count"];
    
    [[TwitterClient sharedInstance] loadUserTweetsWithParams:params completion:^(NSArray * tweets, NSError *error) {
        if(error==nil){
            NSLog(@"ProfileViewController: tweets loaded without error.");
            //NSLog(@"tweets are: %@", responseObject);
            self.myTweets = [NSArray arrayWithArray:tweets];
            NSLog(@"count of tweets is: %ld", self.myTweets.count);
            [self.tweetsTableView reloadData];
        }else{
            NSLog(@"ProfileViewController: tweets loading encounters error: %@", [error localizedDescription]);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
