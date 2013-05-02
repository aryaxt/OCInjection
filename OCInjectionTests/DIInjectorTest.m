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

- (void)testClassToClassBindingShouldReturnCorrectObjectType
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class]];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue([result isKindOfClass:[YahooClient class]], @"Did not populate object correctly");
}

- (void)testProtocolToClassBindingShouldReturnCorrectObjectType
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class]];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue([result isKindOfClass:[Client class]], @"Did not populate object correctly");
}

- (void)testProtocolToInstanceBindingShouldReturnCorrectInstanceOfObject
{
	Client *client = [[Client alloc] init];
	
	[self.module bindProtocol:@protocol(ClientProtocol) toInstance:client];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result == client, @"Did not populate object correctly");
}

- (void)testClassToInstaneBindingShouldReturnCorrectInstanceOfObject
{
	YahooClient *client = [[YahooClient alloc] init];
	
	[self.module bindClass:[YahooClient class] toInstance:client];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result == client, @"Did not populate object correctly");
}

- (void)testClassToClassSingletonBindingShouldReturnTheSameInstanceOfObject
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class] asSingleton:YES];
	id result1 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id result2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result1 == result2, @"Did not populate object correctly");
}

- (void)testProtocolToClassSingletonBindingShouldReturnSameInstanceOfObject
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class] asSingleton:YES];
	id result1 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result1 == result2, @"Did not populate object correctly");
}

- (void)testClassToClassNonSingletonBindingShouldNotReturnCSameInstanceObject
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class] asSingleton:NO];
	id result1 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id result2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result1 != result2, @"Did not populate object correctly");
}

- (void)testProtocolToClassNonSingletonBindingShouldNotReturnSameInstanceOfObject
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class] asSingleton:NO];
	id result1 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result1 != result2, @"Did not populate object correctly");
}

- (void)testClassToClassBindingShouldNotReturnTheSameInstanceObject
{
	[self.module bindClass:[YahooClient class] toClass:[YahooClient class]];
	id result = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	id resul2 = [[DIInjector sharedInstance] resolveForClass:[YahooClient class]];
	
	STAssertTrue(result != resul2, @"Did not populate object correctly");
}

- (void)testProtocolToClassBindingShouldNotReturnTheSameInstanceObject
{
	[self.module bindProtocol:@protocol(ClientProtocol) toClass:[Client class]];
	id result = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	id result2 = [[DIInjector sharedInstance] resolveForProtocol:@protocol(ClientProtocol)];
	
	STAssertTrue(result != result2, @"Did not populate object correctly");
}

@end
