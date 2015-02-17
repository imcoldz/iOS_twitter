//
//  MenuViewController.h
//  ttapp
//
//  Created by Xiangyu Zhang on 2/16/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContainerViewController.h"

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

- (void)didTapHomeline:(MenuViewController *)mvc;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;

@end
