//
//  DIInjectorTest.m
//  OCInjection
//
//  Created by Aryan Ghassemi on 5/1/13.
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

/*- (void)testClassToClassBindingShouldReturnCorrectObjectType
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
}*/

@end
