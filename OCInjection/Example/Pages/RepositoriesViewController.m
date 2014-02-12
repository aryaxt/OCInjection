//
//  ViewController.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
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

#import "RepositoriesViewController.h"
#import "ContributorsViewController.h"

@interface RepositoriesViewController()
@property (nonatomic, strong) id <GitHubClientProtocol> githubClient;
@property (nonatomic, strong) NSArray *repositories;
@end

@implementation RepositoriesViewController
@dynamic githubClient;

#pragma mark - ViewController MEthods -

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (!self.username)
		self.username = @"aryaxt";
	
	self.title = [NSString stringWithFormat:@"%@ repos", self.username];
	
	[self.githubClient fetchRepositoriesByUsername:self.username
									 andCompletion:^(NSArray *repositories, NSError *error) {
										 
		self.repositories = repositories;
		[self.tableView reloadData];
	}];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqual:@"ContributorsViewControllerSegue"])
	{
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		Repository *repo = [self.repositories objectAtIndex:indexPath.row];
		
		ContributorsViewController *vc = segue.destinationViewController;
		vc.selectedRepository = repo;
	}
}

#pragma mark - UITableView Delegate & DataSource Methods -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Repository *repo = [self.repositories objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"repositoryCell"];
	cell.textLabel.text = repo.name;
	cell.textLabel.textColor = [UIColor blueColor];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.detailTextLabel.text = repo.detail;
	
	return cell;
}

@end
