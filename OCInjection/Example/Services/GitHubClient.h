//
//  GitHubClient.h
//  OCInjection
//
//  Created by Aryan Ghassemi on 2/11/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubClientProtocol.h"
#import "ClientProtocol.h"
#import "Repository.h"

@interface GitHubClient : NSObject <GitHubClientProtocol>

- (id)initWithClient:(id <ClientProtocol>)client;

@end
