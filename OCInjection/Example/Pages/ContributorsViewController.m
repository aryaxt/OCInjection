//
//  ContributorsViewController.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "ContributorsViewController.h"
#import "RepositoriesViewController.h"

@interface ContributorsViewController()
@property (nonatomic, strong) id <GitHubClientProtocol> githubClient;
@property (nonatomic, strong) NSArray *contributors;
@end

@implementation ContributorsViewController
@dynamic githubClient;

#pragma mark - ViewController MEthods -https://www.lindyhopvideo.com/media/images/user-placeholder-large.png

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = self.selectedRepository.name;
	
	[self.githubClient fetchContributorsByUsername:self.selectedRepository.owner.login
									repositoryName:self.selectedRepository.name
									 andCompletion:^(NSArray *contributors, NSError *error) {
		self.contributors = contributors;
		[self.tableView reloadData];
	}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqual:@"RepositoriesViewControllerSegue"])
	{
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		User *user = [self.contributors objectAtIndex:indexPath.row];
		
		RepositoriesViewController *vc = segue.destinationViewController;
		vc.username = user.login;
	}
}

#pragma mark - UITableView Delegate & DataSource Methods -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.contributors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	User *user = [self.contributors objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"contributorCell"];
	cell.textLabel.text = user.login;
	cell.textLabel.textColor = [UIColor blueColor];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	
	[cell.imageView setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
	
	return cell;
}

@end
