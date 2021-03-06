//
//  LoginViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/9/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

#import "ContainerViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User * user, NSError * error){
        if(user != nil){
            //modally present user's tweets view
            NSLog(@"welcome to %@", user.name);
            ContainerViewController * cvc = [[ContainerViewController alloc] init];
            [self presentViewController:cvc animated:YES completion:nil];
        }else{
            //present error view
            NSLog(@"tiwtterclient login fail %@", user.name);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
