//
//  MentionsViewController.h
//  ttapp
//
//  Created by Xiangyu Zhang on 2/16/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MentionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User * user;


@end
