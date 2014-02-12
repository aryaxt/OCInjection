//
//  ContributorsViewController.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//
// https://github.com/aryaxt/OCInjection
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ContributorsViewController.h"
#import "RepositoriesViewController.h"

@interface ContributorsViewController()
@property (nonatomic, strong) id <GitHubClientProtocol> githubClient;
@property (nonatomic, strong) NSArray *contributors;
@end

@implementation ContributorsViewController
@dynamic githubClient;

#pragma mark - ViewController MEthods -

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
