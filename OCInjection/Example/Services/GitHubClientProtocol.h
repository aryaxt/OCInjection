//
//  GitHubClientProtocol.h
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubClientProtocol <NSObject>

- (void)fetchRepositoriesByUsername:(NSString *)username andCompletion:(void (^)(NSArray *repositories, NSError *error))completion;
- (void)fetchContributorsByUsername:(NSString *)username repositoryName:(NSString *)repo andCompletion:(void (^)(NSArray *contributors, NSError *error))completion;

@end
