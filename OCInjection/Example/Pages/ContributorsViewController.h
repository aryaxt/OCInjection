//
//  ContributorsViewController.h
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GitHubClient.h"
#import "Repository.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ContributorsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Repository *selectedRepository;

@end
