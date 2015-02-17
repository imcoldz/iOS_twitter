//
//  MenuViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/16/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"


@interface MenuViewController ()
- (IBAction)onHomelineTap:(UIButton *)sender;
- (IBAction)onMentionsTap:(UIButton *)sender;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onProfileTap:(UIButton *)sender {
    ProfileViewController * vc = [[ProfileViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.user = [User currentUser];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onHomelineTap:(UIButton *)sender {
    NSLog(@"from MenuViewController homeline button tapped!");
    [self.delegate didTapHomeline:self];
}

- (IBAction)onMentionsTap:(UIButton *)sender {
    NSLog(@"from MenuViewController mentions button tapped!");
    MentionsViewController * vc = [[MentionsViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.user = [User currentUser];
    [self presentViewController:nvc animated:YES completion:nil];
}
@end
