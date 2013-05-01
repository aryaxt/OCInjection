//
//  DIConfig.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "DIConfig.h"
#import "GoogleClientProtocol.h"
#import "GoogleClient.h"
#import "YahooClient.h"
#import "ClientProtocol.h"
#import "Client.h"

@implementation DIConfig

- (void)configure
{
	[self bindClass:[YahooClient class] toClass:[YahooClient class]];
	[self bindProtocol:@protocol(GoogleClientProtocol) toClass:[GoogleClient class]];
	[self bindProtocol:@protocol(ClientProtocol) toClass:[Client class]];
}

@end
