//
//  DIConfig.m
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

#import "DIConfig.h"
#import "ClientProtocol.h"
#import "Client.h"
#import "ApplicationConfiguration.h"
#import "ApplicationConfigurationProtocol.h"
#import "GitHubClientProtocol.h"
#import "GitHubClient.h"

@implementation DIConfig

- (void)configure
{
	[self bindProtocol:@protocol(ApplicationConfigurationProtocol) toClass:[ApplicationConfiguration class] asSingleton:YES];
	
	// Binding value should be the exact same as the constructor argument type
	(void) [[[self bindProtocol:@protocol(GitHubClientProtocol) toClass:[GitHubClient class]] withConstructor]
		initWithClient:InjectBinding(@protocol(ClientProtocol))];
	
	// Here we inject binding, and we inject value at the same time
	// This is just to demonstrate that you can also inject values into constructor,
	// but the preferred method is to inject binding rather than values.
	(void) [[[self bindProtocol:@protocol(ClientProtocol) toClass:[Client class] asSingleton:YES] withConstructor]
			initWithApplicationConfiguration:InjectBinding(@protocol(ApplicationConfigurationProtocol)) andTimeout:InjectValue(@60)];
	
	[super configure];
}

@end
