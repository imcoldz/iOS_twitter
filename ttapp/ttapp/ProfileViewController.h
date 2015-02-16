//
//  ProfileViewController.h
//  ttapp
//
//  Created by Xiangyu Zhang on 2/15/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User * user;

@end
