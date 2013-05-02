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

- (void)testClassToClassBindingShouldReturnCorrectObject
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class]];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue([result isKindOfClass:[YahooClient class]], @"Did not populate object correctly");
}

- (void)testProtocolToClassBindingShouldReturnCorrectObject
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class]];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue([result isKindOfClass:[Client class]], @"Did not populate object correctly");
}

- (void)testProtocolToInstanceBindingShouldReturnCorrectObject
{
	Client *client = [[Client alloc] init];
	
	[self.module bindProtocol:@protocol(ClientProtocol) toInstance:client];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result == client, @"Did not populate object correctly");
}

- (void)testClassToInstaneBindingShouldReturnCorrectObject
{
	YahooClient *client = [[YahooClient alloc] init];
	
	[self.module bindClass:[YahooClient class] toInstance:client];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result == client, @"Did not populate object correctly");
}

- (void)testClassToClassSingletonBindingShouldReturnCorrectObject
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class] asSingleton:YES];
	id result1 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id result2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result1 == result2, @"Did not populate object correctly");
}

- (void)testProtocolToClassSingleTonBindingShouldReturnCorrectObject
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class] asSingleton:YES];
	id result1 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result1 == result2, @"Did not populate object correctly");
}

- (void)testClassToClassNonSingletonBindingShouldReturnCorrectObject
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class] asSingleton:NO];
	id result1 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id result2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result1 != result2, @"Did not populate object correctly");
}

- (void)testProtocolToClassNonSingleTonBindingShouldReturnCorrectObject
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class] asSingleton:NO];
	id result1 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result1 != result2, @"Did not populate object correctly");
}

- (void)testClassToClassBindingShouldNotReturnTheSameObject
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class]];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id resul2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result != resul2, @"Did not populate object correctly");
}

- (void)testProtocolToClassBindingShouldNotReturnTheSameObject
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class]];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result != result2, @"Did not populate object correctly");
}

@end
