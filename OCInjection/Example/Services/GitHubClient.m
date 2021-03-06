//
//  GitHubClient.m
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
