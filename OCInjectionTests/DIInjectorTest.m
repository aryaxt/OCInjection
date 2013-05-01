//
//  DIInjectorTest.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 5/1/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "DIInjectorTest.h"

@implementation DIInjectorTest
@synthesize module;

- (void)setUp
{
	[super setUp];
	
	self.module = [[DIAbstractModule alloc] init];
	[[DIInjector sharedInstance] setDefaultModule:self.module];
}

- (void)tearDown
{
	self.module = nil;
	
	[super tearDown];
}

- (void)testClassToClassBindingShouldReturnCorrectObjecy
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class]];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue([result isKindOfClass:[YahooClient class]], @"Did not populate object correctly");
}

- (void)testProtocolToClassBindingShouldReturnCorrectObjecy
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class]];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue([result isKindOfClass:[Client class]], @"Did not populate object correctly");
}

- (void)testProtocolToInstanceBindingShouldReturnCorrectObjecy
{
	Client *client = [[Client alloc] init];
	
	[self.module bindProtocol:@protocol(ClientProtocol) toInstance:client];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result == client, @"Did not populate object correctly");
}

- (void)testClassToInstaneBindingShouldReturnCorrectObjecy
{
	YahooClient *client = [[YahooClient alloc] init];
	
	[self.module bindClass:[YahooClient class] toInstance:client];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result == client, @"Did not populate object correctly");
}

- (void)testClassToClassSingletonBindingShouldReturnCorrectObjecy
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class] asSingleton:YES];
	id result1 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id result2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result1 == result2, @"Did not populate object correctly");
}

- (void)testProtocolToClassSingleTonBindingShouldReturnCorrectObjecy
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class] asSingleton:YES];
	id result1 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result1 == result2, @"Did not populate object correctly");
}

- (void)testClassToClassNonSingletonBindingShouldReturnCorrectObjecy
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class] asSingleton:NO];
	id result1 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id result2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result1 != result2, @"Did not populate object correctly");
}

- (void)testProtocolToClassNonSingleTonBindingShouldReturnCorrectObjecy
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class] asSingleton:NO];
	id result1 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result1 != result2, @"Did not populate object correctly");
}

@end
