//
//  ComposeViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/12/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *composeTextView;

@property (nonatomic, assign) BOOL isEditing;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isEditing = YES;
    if([self.composeTextView canBecomeFirstResponder]){
        [self.composeTextView becomeFirstResponder];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target: self action:@selector(onBackButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target: self action:@selector(onTweetButton)];
    
    User *user = [User currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    self.isEditing = !self.isEditing;
    [[self view ] endEditing:self.isEditing];
}

- (void) onBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onTweetButton{
    NSLog(@"sending tweet to TwitterClient %@", self.composeTextView.text);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *statusString = self.composeTextView.text;
    [params setObject:statusString forKey:@"status"];
    [[TwitterClient sharedInstance] updateWithParams:params completion:^(NSObject * responseObject, NSError *error) {
        if(error==nil){
            NSLog(@"ComposeViewController: status updated without error.");
        }else{
            NSLog(@"ComposeViewController: status updated with error.");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
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
