//
//  DIContructorInjectorProxy.m
//  OCInjection
//
//  Created by Aryan Gh on 2/9/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
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

#import "DIContructorInjectorProxy.h"

@interface DIContructorInjectorProxy()
@property (nonatomic, strong) id object;
@property (nonatomic, weak) id <DIContructorInjectorProxyDelegate> delegate;
@end

@implementation DIContructorInjectorProxy

#pragma mark - Initialization -

- (id)initWithClass:(Class)class bindingKey:(NSString *)bindingKey andDelegate:(id <DIContructorInjectorProxyDelegate>)delegate;
{
	_proxyClass = class;
	_bindingKey = bindingKey;
	self.delegate = delegate;
	self.object = [[class alloc] init];
	
	return self;
}

#pragma mark - Public Methods -

- (id)withConstructor
{
	return self;
}

#pragma mark - NSProxy Methods -

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	NSMutableString *selectorName = [NSStringFromSelector(anInvocation.selector) mutableCopy];
	NSUInteger numberOfColumnsInMethodName = [selectorName replaceOccurrencesOfString:@":"
																		   withString:@":"
																			  options:NSLiteralSearch
																				range:NSMakeRange(0, selectorName.length)];
	
	[anInvocation retainArguments];
	NSMutableArray *argumentsPassedToSelector = [NSMutableArray array];
	
	for (int i=2 ; i<numberOfColumnsInMethodName+2 ; i++)
	{
		NSString *argument;
		[anInvocation getArgument:&argument atIndex:i];
		[argumentsPassedToSelector addObject:[NSString stringWithFormat:@"%@", argument]];
	}
	
	[self.delegate dIContructorInjectorProxy:self didSelectSelector:anInvocation.selector withArgumentTypes:argumentsPassedToSelector];

    return;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.object methodSignatureForSelector:aSelector];
}

@end
