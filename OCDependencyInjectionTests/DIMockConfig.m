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

+ (void)setup
{
	OCMockObject *yahooClientMock = [OCMockObject niceMockForClass:[YahooClient class]];
	OCMockObject *googleClientMock = [OCMockObject mockForProtocol:@protocol(GoogleClientProtocol)];
	OCMockObject *mockClient = [OCMockObject mockForProtocol:@protocol(ClientProtocol)];
	
	[[DIInjector sharedInstance] bindClass:[YahooClient class] toInstance:yahooClientMock];
	[[DIInjector sharedInstance] bindProtocol:@protocol(GoogleClientProtocol) toInstance:googleClientMock];
	[[DIInjector sharedInstance] bindProtocol:@protocol(ClientProtocol) toInstance:mockClient];
}

@end
