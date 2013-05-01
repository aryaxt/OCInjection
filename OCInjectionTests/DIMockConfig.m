//
//  DIMockInjector.m
//  OCDependencyInjection
//
//  Created by Aryan Gh on 4/28/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "DIMockConfig.h"
#import "DIInjector.h"
#import "GoogleClient.h"
#import "GoogleClientProtocol.h"
#import "YahooClient.h"

@implementation DIMockConfig

- (void)configure
{
	OCMockObject *yahooClientMock = [OCMockObject niceMockForClass:[YahooClient class]];
	OCMockObject *googleClientMock = [OCMockObject mockForProtocol:@protocol(GoogleClientProtocol)];
	OCMockObject *mockClient = [OCMockObject mockForProtocol:@protocol(ClientProtocol)];
	
	[self bindClass:[YahooClient class] toInstance:yahooClientMock];
	[self bindProtocol:@protocol(GoogleClientProtocol) toInstance:googleClientMock];
	[self bindProtocol:@protocol(ClientProtocol) toInstance:mockClient];
}

@end
