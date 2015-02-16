//
//  ContainerViewController.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/16/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "ContainerViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"

@interface ContainerViewController ()

@property (nonatomic, strong) MenuViewController * menuVC;

@property (nonatomic, strong) TweetsViewController * tweetsVC;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.menuVC = [[MenuViewController alloc] init];
    self.tweetsVC = [[TweetsViewController alloc] init];

    [self displayContentController:self.tweetsVC];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.navigationController.view addGestureRecognizer:panGestureRecognizer];
    
    
    //[self addChildViewController:self.tweetsVC];
    //self.tweetsVC.view.frame = self.view.frame;
    //[self.view addSubview:self.tweetsVC.view];
    //[self.tweetsVC didMoveToParentViewController:self];
    //[self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) displayContentController: (UIViewController*) content;
{
    [self.navigationController addChildViewController:content];// 1
    content.view.frame = self.navigationController.view.frame; // 2
    [self.navigationController.view addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}

- (void)onCustomPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.navigationController.view];
    CGRect frame = self.tweetsVC.view.frame;
    frame.origin.x = translation.x;
    //self.tweetsVC.view.frame = frame;
    self.tweetsVC.view.frame = frame;
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