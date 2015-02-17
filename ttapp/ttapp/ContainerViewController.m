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

@interface ContainerViewController ()<MenuViewControllerDelegate>

@property (nonatomic, strong) MenuViewController * menuVC;

@property (nonatomic, strong) UINavigationController * nvc;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.menuVC = [[MenuViewController alloc] init];
    self.menuVC.view.frame = self.contentView.frame;
    self.menuVC.delegate = self;
    [self.contentView addSubview:self.menuVC.view];
    
    self.nvc = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
    self.nvc.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.nvc.view];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.contentView addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onCustomPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.navigationController.view];
    CGPoint velocity = [sender velocityInView:self.navigationController.view];
    
    //# version no.1
    if( sender.state == UIGestureRecognizerStateBegan){}
    else if (sender.state == UIGestureRecognizerStateChanged){
        if(translation.x>0){
            CGRect frame = self.nvc.view.frame;
            frame.origin.x = translation.x;
            self.nvc.view.frame = frame;
        }
    }
    else if  (sender.state == UIGestureRecognizerStateEnded){
    
        if (velocity.x>0){
            //moving to right
            [UIView animateWithDuration:0.6 animations:^{
                CGRect frame = self.nvc.view.frame;
                frame.origin.x=200;
                self.nvc.view.frame = frame;
            }];
        }
        else{
            [UIView animateWithDuration:0.6 animations:^{
                CGRect frame = self.nvc.view.frame;
                frame.origin.x = 0;
                self.nvc.view.frame = frame;
            }];
        }
    }
}

- (void) didTapHomeline:(MenuViewController *)mvc{
    NSLog(@"from ContainerViewController - got homeline button clicked signal!");
    [UIView animateWithDuration:0.6 animations:^{
        CGRect frame = self.nvc.view.frame;
        frame.origin.x = 0;
        self.nvc.view.frame = frame;
    }];
}
@end