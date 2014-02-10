//
//  DIContructorInjectorProxy.m
//  OCInjection
//
//  Created by Aryan Gh on 2/9/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

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
