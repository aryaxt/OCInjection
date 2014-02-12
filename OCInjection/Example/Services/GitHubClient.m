//
//  GitHubClient.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "GitHubClient.h"

@interface GitHubClient()
@property (nonatomic, strong) id <ClientProtocol> client;
@end

@implementation GitHubClient

#pragma mark - Initialization -

- (id)initWithClient:(id <ClientProtocol>)client
{
	if (self = [super init])
	{
		self.client = client;
	}
	
	return self;
}

#pragma mark - Public Methods -

- (void)fetchRepositoriesByUsername:(NSString *)username andCompletion:(void (^)(NSArray *repositories, NSError *error))completion
{
	[self.client fetchGetWithUrl:[NSString stringWithFormat:@"/users/%@/repos", username]
					  resultType:[Repository class]
				   andCompletion:completion];
}

- (void)fetchContributorsByUsername:(NSString *)username repositoryName:(NSString *)repo andCompletion:(void (^)(NSArray *contributors, NSError *error))completion
{
	[self.client fetchGetWithUrl:[NSString stringWithFormat:@"/repos/%@/%@/contributors", username, repo]
					  resultType:[User class]
				   andCompletion:completion];
}

@end
